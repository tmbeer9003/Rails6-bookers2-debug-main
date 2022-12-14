class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @booknew = Book.new
    @user = @book.user
    @comment = BookComment.new
    impressionist(@book, nil, :unique => [:ip_address])

  end

  def index
    if params[:sort] == nil
      to = Time.current.at_end_of_day
      from = to - 1.week
      @books = Book.includes(:favorites).sort {
        |a,b| b.favorites.where(created_at: from..to).size <=>
        a.favorites.where(created_at: from..to).size
        }
    else
      @books = Book.all.order(params[:sort])
    end
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_list = params[:book][:tag_name].split(',')
    if @book.save
      @book.save_tag(tag_list)
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    @book_tag = @book.book_tags.pluck(:tag_name).join(',')
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    tag_list = params[:book][:tag_name].split(',')
    if @book.update(book_params)
      @book.save_tag(tag_list)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :evaluation)
  end
end
