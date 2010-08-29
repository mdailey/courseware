class LectureNotesController < FileListController

  protected
  
  def find_file_list
    @file_list = @course.lecture_notes
  end
  
  def find_blurb
    @blurb = @course.lecture_notes_blurb
  end
  
  def set_file
    lecture_note = @course.lecture_notes.find(params[:id])
    if lecture_note and lecture_note.lecture_note_file
      @file_data = lecture_note.lecture_note_file.file_data
      @file_name = lecture_note.file_name
      @file_label = lecture_note.file_label
    end
  end
  
  def edit_path(course)
    edit_lecture_notes_path(course)
  end

  def fix_attributes
    if params[:course] and !params[:course][:existing_lecture_note_attributes]
      params[:course][:existing_lecture_note_attributes] = {}
    end
  end
 
end
