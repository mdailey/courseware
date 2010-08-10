class ReadingsController < ApplicationController
  require_role 'admin', :for_all_except => [:index]

  # Add a method to the model to strip its title's HTML tags
  Reading.send :define_method, :stripped_title do
    ActionController::Base.helpers.strip_tags(title)
  end
    
  def index
    setup
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @course_readings }
    end
  end
  
  def edit
    setup
    @course_readings.build
  end
  
  def update
    @course = Course.find(params[:course_id])
    fix_readings_attributes(params)

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to(edit_course_readings_path(@course), :notice => 'Readings were successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  private
  
  def setup
    @course = Course.find(params[:course_id])
    @course_readings = @course.course_readings
    @blurb = @course.readings_blurb
  end
  
  def fix_readings_attributes(params)
    if params[:course] and !params[:course][:existing_course_reading_attributes]
      params[:course][:existing_course_reading_attributes] = {}
    end
  end

end
