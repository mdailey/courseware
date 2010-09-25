class AssignmentsController < FileListController

  protected
  
  def find_file_list
    @file_list = @course.assignments
  end
  
  def find_blurb
    @blurb = @course.assignments_blurb
  end
  
  def set_file
    assignment = @course.assignments.find(params[:id])
    if assignment
      @file_name, @file_label, @file_data = assignment.document_info
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
