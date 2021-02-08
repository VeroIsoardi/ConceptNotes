class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy export]

  
  # GET /notes/new
  def new
    @note = Note.new
    @note.book_id = params[:book]
    
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  def create
    @note = current_user.notes.new(note_params)
    if @note.save
      flash[:notice] = "Note was successfully created."
      if @note.book_id == nil
        redirect_to :root
      else
        redirect_to book_path(@note.book_id)
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1 
  def update
    if @note.update(note_params)
      flash[:notice] = "Note was successfully updated."
      if @note.book_id == nil
        redirect_to :root
      else
        redirect_to book_path(@note.book_id)
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
    flash[:notice] = "Note was successfully deleted."
    if @note.book_id == nil
      redirect_to :root
    else
      redirect_to book_path(@note.book_id)
    end
  end

  def export 
    @html = CommonMarker.render_html("**#{@note.title}**", :DEFAULT)
    @html << CommonMarker.render_html('---', :DEFAULT)
    @html << CommonMarker.render_html(@note.content, :DEFAULT)  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = Note.find(params[:id])
    if (@note.user_id == current_user.id)
      return @note
    else
      flash[:error] = "Uh oh wrong page!"
      redirect_to :root
    end
  end
  
  # Only allow a list of trusted parameters through.
  def note_params
    params.require(:note).permit(:title, :content, :book_id)
  end
end
