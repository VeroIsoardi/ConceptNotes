class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy export]
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
      flash[:notice] = "Book was successfully created."
      redirect_to :root
    else
      render :new, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      flash[:notice] = "Book was successfully updated."
      redirect_to :root
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
    flash[:notice] = "Book was successfully deleted."
    redirect_to :root
  end

  def show
    @notes = @book.notes.where(user_id: current_user.id)
  end
  
  def export
    @html = CommonMarker.render_html(@book.title, :DEFAULT)
    @book.notes.each do |note|
      @html << CommonMarker.render_html('***', :DEFAULT)
      @html << CommonMarker.render_html("**#{note.title}**", :DEFAULT)
      @html << CommonMarker.render_html('---', :DEFAULT)
      @html << CommonMarker.render_html(note.content, :DEFAULT, [:table, :tasklist, :strikethrough, :autolink, :tagfilter])  
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
      if !(@book.user_id == current_user.id)
        flash[:error] = "Uh oh wrong page!"
        redirect_to :root
      else
        return @book
      end
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title)
    end
end
