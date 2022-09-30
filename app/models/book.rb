class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where(title: word)
    elsif search == "forward_match"
      @book = Book.where("title like ?", "#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title like ?", "%#{word}")
    else
      @book = Book.where("title like ?", "%#{word}%")
    end
  end
end
