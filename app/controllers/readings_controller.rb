class ReadingsController < ApplicationController
  require_role 'admin', :for_all_except => [:index]

  def index
    @course = Course.find(params[:course_id])
    @course_readings = @course.course_readings
    @menu_actions = @course.menu_actions
    @blurb = @course.readings_blurb

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @course_readings }
    end

  end

end
