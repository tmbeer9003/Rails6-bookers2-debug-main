class CreateBookTagRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :book_tag_relationships do |t|
      t.references :book, null: false, foreign_key: true
      t.references :book_tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
