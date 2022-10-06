class BookTagRelationship < ApplicationRecord
  belongs_to :book
  belongs_to :book_tag
  validates :book_id, presence: true
  validates :book_tag_id, presence: true
end
