class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.belongs_to :user, null: false
      t.timestamps
      
    end
    add_index :books,[:user_id, :title ], unique: true
  end
end
