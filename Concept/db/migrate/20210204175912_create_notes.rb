class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :content
      t.belongs_to :book,  null: true 
      t.belongs_to :user, null: false
      t.timestamps
    end
  end
end
