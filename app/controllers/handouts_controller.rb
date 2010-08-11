class HandoutsController < ApplicationController
  require_role 'admin', :for_all_except => [:index, :show]

  def index
    @course = Course.find(params[:course_id])
    @handouts = @course.handouts
    @blurb = @course.handouts_blurb

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @handouts }
    end
  end
  
  def show
    @course = Course.find(params[:course_id])
    @handout = @course.handouts.find(params[:id])
    file = @handout.handout_file
    if file
      send_data Base64.decode64( file.file_data ), :filename => @handout.file_name, :type => mimetype(@handout.file_label)
    else
      raise 'No file data for handout.'
    end
  end
  
end
