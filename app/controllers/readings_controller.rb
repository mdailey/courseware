class ReadingsController < ApplicationController
  
  require_role ['admin','instructor'], :for => [:update, :edit]

  before_filter :find_course
  before_filter :find_blurb, :only => [:index, :edit]
  before_filter :find_course_readings, :only => [:index, :edit]

  # Add a method to the model to strip its title's HTML tags
  Reading.send :define_method, :stripped_title do
    ActionController::Base.helpers.strip_tags(title)
  end
    
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @course_readings }
    end
  end
  
  def edit
    setup_for_edit
  end

  def update
    fix_readings_attributes(params)

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to(edit_course_readings_path(@course), :notice => 'Readings were successfully updated.') }
        format.xml  { head :ok }
      else
        format.html do
          setup_for_edit
          render :action => "edit"
        end
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  protected
  
  def setup_for_edit
    if @course_readings.select { |cr| cr.new_record? }.size == 0
      @course_readings.build
    end
    @readings = Reading.find(:all)
  end
        
  def find_course
    @course = Course.find(params[:course_id])
  end

  def find_course_readings
    @course_readings = @course.course_readings
  end
      
  def find_blurb
    @blurb = @course.readings_blurb
  end
  
  def fix_readings_attributes(params)
    if params[:course] and !params[:course][:existing_course_reading_attributes]
      params[:course][:existing_course_reading_attributes] = {}
    end
  end

end
