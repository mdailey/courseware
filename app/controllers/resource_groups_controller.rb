class ResourceGroupsController < ApplicationController
  require_role 'admin', :for_all_except => [:index]

  def index
    @course = Course.find(params[:course_id])
    @course_resources = @course.course_resources
    @menu_actions = @course.menu_actions
    @blurb = @course.resources_blurb

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @course_resources }
    end

  end

end
