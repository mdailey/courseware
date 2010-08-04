class CoursesController < ApplicationController
  require_role 'admin', :for_all_except => [:index, :show, :static]
  before_filter :store_location
  
  def index
    @courses = Course.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.xml
  def show
    @course = Course.find(params[:id])
    @title = 'Courses: ' + action_name
    @instructors = @course.main_instructors
    @tas = @course.tas
    @menu_actions = @course.menu_actions

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.xml
  def new
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
    @title = 'Courses: ' + action_name
    @menu_actions = @course.menu_actions
  end

  # POST /courses
  # POST /courses.xml
  def create
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to(@course, :notice => 'Course was successfully created.') }
        format.xml  { render :xml => @course, :status => :created, :location => @course }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.xml
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to(@course, :notice => 'Course was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.xml
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to(courses_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /courses/1/paper_list
  def static
    @course = Course.find(params[:id])
    @menu_actions = @course.menu_actions
    static_action = params[:static_action]
    menu_action = @course.menu_actions.select { |mi| mi.action == static_action }.first
    if menu_action
      file_path = File.expand_path STATIC_FILE_PATH + '/' + menu_action.path
      if file_path.start_with? STATIC_FILE_PATH and File.readable? file_path and !File.directory? file_path
        @file_path = file_path
        @file_contents = strip_headers(File.read(file_path))
      else
        logger.error 'ERROR: invalid static path: ' + file_path
      end
    else
      logger.error 'ERROR: unknown static action: ' + static_action
    end
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  private
  
  def strip_headers( s )
    s.gsub /^<![^>]*>/, ''
  end
end
