class LecturesController < ApplicationController
  require_role 'admin', :for_all_except => [:index]
  
  def index
    @course = Course.find(params[:course_id])
    @lectures = @course.lectures
    @blurb = @course.lectures_blurb

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lectures }
    end
  end

end
