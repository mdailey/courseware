class AssignmentsController < ApplicationController
  require_role 'admin', :for_all_except => [:index, :show]

  def index
    @course = Course.find(params[:course_id])
    @assignments = @course.assignments
    @blurb = @course.assignments_blurb

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assignments }
    end
  end
  
  def show
    @course = Course.find(params[:course_id])
    @assignment = @course.assignments.find(params[:id])
    file = @assignment.assignment_file
    if file
      send_data Base64.decode64( file.file_data ), :filename => @assignment.ps_fname, :type => mimetype(@assignment.ps_flabel)
    else
      raise 'No file data for assignment.'
    end
  end

end
