class Book < ApplicationRecord
  belongs_to :user, inverse_of: :books
  has_many :notes, inverse_of: :book, dependent: :destroy

  validates :title, length: { maximum: 255 }, presence: true, uniqueness: { scope: :user_id }
end
