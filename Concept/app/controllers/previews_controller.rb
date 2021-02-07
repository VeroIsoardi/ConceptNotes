require 'commonmarker'
class PreviewsController < ApplicationController
  def index
    @books = current_user.books
    @notes = current_user.notes.where(book_id: nil)
  end

  def export
    @html = CommonMarker.render_html("# TODAS LAS NOTAS", :DEFAULT)
    @html << CommonMarker.render_html('CUADERNOS', :DEFAULT)
    current_user.books.each do |book|
      @html << CommonMarker.render_html("***#{book.title}***", :DEFAULT)
      book.notes.each do |note|
        @html << CommonMarker.render_html('***', :DEFAULT)
        @html << CommonMarker.render_html("**#{note.title}**", :DEFAULT)
        @html << CommonMarker.render_html('---', :DEFAULT)
        @html << CommonMarker.render_html(note.content, :DEFAULT)  
      end
      @html << CommonMarker.render_html('***', :DEFAULT)
    end
    @html << CommonMarker.render_html('NOTAS', :DEFAULT)
    current_user.notes.where(book_id: nil).each do |note|
      @html << CommonMarker.render_html('***', :DEFAULT)
      @html << CommonMarker.render_html("**#{note.title}**", :DEFAULT)
      @html << CommonMarker.render_html('---', :DEFAULT)
      @html << CommonMarker.render_html(note.content, :DEFAULT)  
    end
  end  
end
