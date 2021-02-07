class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :require_login

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books 
  def create
    @book = current_user.books.new(book_params)
    if @book.save
      redirect_to :root, notice: "Book was successfully created."
    else
      render :new, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      redirect_to :root, notice: "Book was successfully updated."
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
    redirect_to :root, notice: "Book was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
      if !(@book.user_id == current_user.id)
        redirect_to :root, notice: "Uh oh the page you were looking for doesn't exist."
      else
        return @book
      end
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title)
    end
end
