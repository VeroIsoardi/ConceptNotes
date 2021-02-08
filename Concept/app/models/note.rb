class Note < ApplicationRecord
  belongs_to :user, inverse_of: :notes 
  belongs_to :book, inverse_of: :notes, optional: true
  validates :title, presence: true, length: {maximum: 255}, uniqueness: { scope: [:book_id, :user_id]}
  validates :content, presence: true
end
