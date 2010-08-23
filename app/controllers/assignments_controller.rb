class AssignmentsController < ApplicationController
  
  require_role 'admin', :for_all_except => [:index, :show]

  before_filter :find_course
  
  def index
    @assignments = @course.assignments
    @blurb = @course.assignments_blurb

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assignments }
    end
  end
  
  def show
    @assignment = @course.assignments.find(params[:id])
    file = @assignment.assignment_file
    if file
      send_data Base64.decode64( file.file_data ), :filename => @assignment.ps_fname, :type => mimetype(@assignment.ps_flabel)
    else
      raise 'No file data for assignment.'
    end
  end

  protected
  
  def find_course
    @course = Course.find(params[:course_id])
  end
  
end
