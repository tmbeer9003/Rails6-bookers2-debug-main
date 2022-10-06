class SearchesController < ApplicationController

  def search
    @range = params[:range]
    if @range == "User"
      @users = User.search_by(params[:search], params[:word])
    elsif @range == "Book"
      @books = Book.search_by(params[:search], params[:word])
    else
      if BookTag.exists?(tag_name: params[:word])
        @book_tag = BookTag.find_by(tag_name: params[:word])
        @books = @book_tag.books
      else
        @books = Book.search_by("perfect_match", "")
      end
    end
  end
    
end
