class AssignmentsController < FileListController

#      send_data Base64.decode64( file.file_data ), :filename => @assignment.ps_fname, :type => mimetype(@assignment.ps_flabel)

  protected
  
  def find_file_list
    @file_list = @course.assignments
  end
  
  def find_blurb
    @blurb = @course.assignments_blurb
  end
  
  def set_file
    assignment = @course.assignments.find(params[:id])
    if assignment and assignment.assignment_file
      @file_data = assignment.assignment_file.file_data
      @file_name = assignment.ps_fname
      @file_label = assignment.ps_flabel
    end
  end
  
  def edit_path(course)
    edit_assignments_path(course)
  end

  def fix_attributes
    if params[:course] and !params[:course][:existing_assignment_attributes]
      params[:course][:existing_assignment_attributes] = {}
    end
  end
 
end
