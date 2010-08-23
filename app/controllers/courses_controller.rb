class CoursesController < ApplicationController
  require_role 'admin', :for_all_except => [:index, :show, :static]
  before_filter :store_location
  before_filter :find_course, :except => [:index,:new,:create]

  # GET /courses
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
    @title = 'Courses: ' + action_name
    @instructors = @course.main_instructors
    @tas = @course.tas

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.xml
  def new
    @course = Course.new
    setup_for_new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/1/edit
  def edit
    setup_for_edit
  end

  # POST /courses
  # POST /courses.xml
  def create
    @course = Course.new(params[:course])

    respond_to do |format|
      logger.debug "About to attempt to save"
      logger.debug @course.inspect
      logger.debug @course.course_instructors.inspect
      if @course.save
        format.html {
          if params[:commit] != 'Create'
            redirect_to(edit_course_path(@course), :notice => 'Course was successfully created.')
          else
            redirect_to(@course, :notice => 'Course was successfully created.')
          end }
        format.xml  { render :xml => @course, :status => :created, :location => @course }
      else
        setup_for_new
        format.html { render :action => "new" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.xml
  def update
    fix_instructors(params)

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html {
          if params[:commit] != 'Update'
            redirect_to(edit_course_path(@course), :notice => 'Course was successfully updated.')
          else
            redirect_to(@course, :notice => 'Course was successfully updated.')
          end }
        format.xml  { head :ok }
      else
        setup_for_edit
        format.html { render :action => "edit" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.xml
  def destroy
    @course.destroy

    respond_to do |format|
      format.html { redirect_to(courses_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /courses/1/paper_list
  def static
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
  
  protected
  
  def strip_headers( s )
    s.gsub /^<![^>]*>/, ''
  end

  def fix_instructors(params)
    if params[:course] and !params[:course][:existing_course_instructor_attributes]
      params[:course][:existing_course_instructor_attributes] = {}
    end
  end
  
  def setup_for_edit
    @course.course_instructors.build :role => 'main'
    @course.course_instructors.build :role => 'ta'
    @title = 'Courses: ' + action_name
  end

  def setup_for_new
    @course.course_instructors.build :role => 'main'
    @course.course_instructors.build :role => 'ta'
  end

  def find_course
    @course = Course.find(params[:id])
  end

end
