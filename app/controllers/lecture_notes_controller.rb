require 'base64'

class LectureNotesController < ApplicationController
  require_role 'admin', :for_all_except => [:index, :show]

  def index
    @course = Course.find(params[:course_id])
    @lecture_notes = @course.lecture_notes
    @blurb = @course.lecture_notes_blurb

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lecture_notes }
    end

  end
  
  def show
    @course = Course.find(params[:course_id])
    @lecture_note = @course.lecture_notes.find(params[:id])
    file = @lecture_note.lecture_note_file
    if file
      send_data decode64( file.file_data ), :filename => @lecture_note.file_name, :type => mimetype(@lecture_note.file_label)
    else
      raise 'No file data for lecture notes'
    end
  end
  
end
