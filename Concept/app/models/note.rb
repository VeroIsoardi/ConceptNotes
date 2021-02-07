class Note < ApplicationRecord
  belongs_to :user, inverse_of: :notes 
  belongs_to :book, inverse_of: :notes, optional: true
  validates :title, presence: true, uniqueness: { case_sensitive: false}, length: {maximum: 255}
  validates :content, presence: true
  validates :title,uniqueness: {scope: [:user_id, :book_id]}

end
