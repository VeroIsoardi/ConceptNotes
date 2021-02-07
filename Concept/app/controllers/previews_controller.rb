class PreviewsController < ApplicationController
  def index
    @books = current_user.books
    @notes = current_user.notes.where(book_id: nil)
  end
end
