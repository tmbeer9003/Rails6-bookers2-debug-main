class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @my_user_room = UserRoom.where(user_id: current_user.id)
    @another_user_room = UserRoom.where(user_id: @user.id)
    unless @user == current_user
      @my_user_room.each do |my_room|
        @another_user_room.each do |another_room|
          if my_room.room_id == another_room.room_id
            @existing_room = true
            @room_id = my_room.room_id
          end
        end
      end
      unless @existing_room == true
        @room = Room.new
        @user_room = UserRoom.new
      end
    end
            
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
