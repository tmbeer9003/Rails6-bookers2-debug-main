class RoomsController < ApplicationController
  
  def create
    @room = Room.create
    @user_room_a = UserRoom.create(room_id: @room.id, user_id: current_user.id)
    @user_room_b = UserRoom.create(params.require(:user_room).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    @room = Room.find(params[:id])
    @user_room = UserRoom.where.not(user_id: current_user.id).find_by(room_id: @room.id)
    @user = @user_room.user
    if UserRoom.where(user_id: current_user.id,room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @user_rooms = @room.user_rooms
    else
      redirect_back(fallback_location: root_path)
    end
  end
end