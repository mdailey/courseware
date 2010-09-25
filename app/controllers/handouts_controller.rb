class HandoutsController < FileListController

  protected
  
  def find_file_list
    @file_list = @course.handouts
  end
  
  def find_blurb
    @blurb = @course.handouts_blurb
  end
  
  def set_file
    handout = @course.handouts.find(params[:id])
    if handout
      @file_name, @file_label, @file_data = handout.document_info
    end
  end
  
  def edit_path(course)
    edit_handouts_path(course)
  end

  def fix_attributes
    if params[:course] and !params[:course][:existing_handout_attributes]
      params[:course][:existing_handout_attributes] = {}
    end
  end

end
