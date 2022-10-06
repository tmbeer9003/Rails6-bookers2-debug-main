class BookTag < ApplicationRecord
  has_many :book_tag_relationships, dependent: :destroy, foreign_key: 'book_tag_id'
  has_many :books, through: :book_tag_relationships
  validates :tag_name, uniqueness: true
end
