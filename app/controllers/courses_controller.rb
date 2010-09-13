class CoursesController < ApplicationController
  require_role 'admin', :for => [:new, :create, :clone, :destroy]
  require_role ['admin','instructor'], :for => [:update, :edit]
  
  before_filter :store_location
  
  before_filter :except => [:index, :new, :create] do |controller|
    controller.instance_eval do
      @course = Course.find(params[:id])
      @title = @course.code + ':' + @course.name + ', ' + @course.semester + ' ' + @course.year.to_s
    end
  end
      
  before_filter :find_people, :only => [:edit, :new, :clone, :update, :create]
  before_filter :build_course_instructors, :only => [:edit, :new, :clone]

  # Prevent instructors from editing other instructors' courses  
  before_filter :only => [:edit, :update] do |controller|
    controller.instance_eval do
      if !@course.user_authorized_for?(current_user,:edit)
        access_denied
      end
    end
  end

  # GET /courses
  def index
    @courses = Course.all
    @title = 'Course list'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @courses }
    end
  end
  
  # GET /courses/1
  # GET /courses/1.xml
  def show
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
    @title = 'New course'
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.xml
  def create
    @course = Course.new(params[:course])
    @title = 'New course'

    respond_to do |format|
      if @course.save
        format.html do
          if params[:commit] != 'Create'
            redirect_to(edit_course_path(@course), :notice => 'Course was successfully created.')
          else
            redirect_to(@course, :notice => 'Course was successfully created.')
          end
        end
        format.xml  { render :xml => @course, :status => :created, :location => @course }
      else
        build_course_instructors
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
        format.html do
          if params[:commit] != 'Update'
            redirect_to(edit_course_path(@course), :notice => 'Course was successfully updated.')
          else
            redirect_to(@course, :notice => 'Course was successfully updated.')
          end
        end
        format.xml  { head :ok }
      else
        build_course_instructors
        format.html { render :action => "edit" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /courses/1/clone
  def clone
    @new_course = @course.clone
    @new_course.set_date
    begin
      @new_course.clone_associations!(@course)
      redirect_to(edit_course_path(@new_course), :notice => 'Course was successfully cloned.')
    rescue
      @course = @new_course
      respond_to do |format|
        format.html { render :action => "new" }
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
  
  def build_course_instructors
    if !@course
      @course = Course.new
    end
    if @course.course_instructors.select { |cr| cr.new_record? and cr.role == 'main' }.size == 0
      @course.course_instructors.build :role => 'main'
    end
    if @course.course_instructors.select { |cr| cr.new_record? and cr.role == 'ta' }.size == 0
      @course.course_instructors.build :role => 'ta'
    end
  end

  def find_people
    @people = Person.find(:all)
  end

end
