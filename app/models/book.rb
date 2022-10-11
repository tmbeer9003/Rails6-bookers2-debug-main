class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_tag_relationships, dependent: :destroy
  has_many :book_tags, through: :book_tag_relationships
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  is_impressionable

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_by(search, word)
    if search == "perfect_match"
      Book.where(title: word)
    elsif search == "forward_match"
      Book.where("title like ?", "#{word}%")
    elsif search == "backward_match"
      Book.where("title like ?", "%#{word}")
    else
      Book.where("title like ?", "%#{word}%")
    end
  end

  def save_tag(newer_tags)
    existing_tags = self.book_tags.pluck(:tag_name) unless self.book_tags.nil?
    old_tags = existing_tags - newer_tags
    new_tags = newer_tags - existing_tags

    old_tags.each do |old_tag|
      self.book_tags.delete BookTag.find_by(tag_name: old_tag)
    end

    new_tags.each do |new_tag|
      book_tag = BookTag.find_or_create_by(tag_name: new_tag)
      self.book_tags << book_tag
    end
  end
end