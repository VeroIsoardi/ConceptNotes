class Book < ApplicationRecord
  belongs_to :user, inverse_of: :books
  has_many :notes, inverse_of: :book, dependent: :destroy 
  validates :title, presence: true, uniqueness: { case_sensitive: false}, length: {maximum: 255}
end
