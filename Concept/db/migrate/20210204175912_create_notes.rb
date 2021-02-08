class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :content
      t.belongs_to :book,  null: true,foreign_key: true
      t.belongs_to :user, null: false,foreign_key: true
      t.timestamps
    end
    add_index :notes, %i[book_id title user_id], unique: true
  end
end
