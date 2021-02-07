class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]

  
  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  def create
    @note = current_user.notes.new(note_params)
    if @note.save
      redirect_to :root, notice: "Note was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1 
  def update
    if @note.update(note_params)
      redirect_to :root, notice: "Note was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
    redirect_to :root, notice: "Note was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = Note.find(params[:id])
    if (@note.user_id == current_user.id)
      return @note
    else
      redirect_to :root, notice: "Uh oh the page you are looking for doesn't exist."
    end
  end
  
  # Only allow a list of trusted parameters through.
  def note_params
    params.require(:note).permit(:title, :content)
  end
end
