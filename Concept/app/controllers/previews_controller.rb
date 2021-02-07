class PreviewsController < ApplicationController
  def index
    @books = current_user.books
    @list = current_user.books.first 3
  end
end
