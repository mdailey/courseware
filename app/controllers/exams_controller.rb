class ExamsController < ApplicationController
  require_role 'admin', :for_all_except => [:index]

  def index
    @course = Course.find(params[:course_id])
    @exams = @course.exams
    @menu_actions = @course.menu_actions
    @blurb = @course.exams_blurb

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @courses }
    end

  end

end
