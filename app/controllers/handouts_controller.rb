class HandoutsController < ApplicationController
  require_role 'admin', :for_all_except => [:index, :show]

  def index
    setup

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
  
  def edit
    setup
    @handouts.build
  end
  
  def update
    @course = Course.find(params[:course_id])
    fix_handouts_attributes(params)

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to(edit_handouts_path(@course), :notice => 'Handouts successfully updated.') }
        format.xml  { head :ok }
      else
        format.html do
          @handouts = @course.handouts
          if @handouts.select { |h| h.new_record? }.size == 0
            @handouts.build
          end
          render :action => "edit"
        end
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def setup
    @course = Course.find(params[:course_id])
    #@handouts = @course.handouts.sort { |h1,h2| h1.number <=> h2.number }
    @handouts = @course.handouts
    @blurb = @course.handouts_blurb
  end

  def fix_handouts_attributes(params)
    if params[:course] and !params[:course][:existing_handout_attributes]
      params[:course][:existing_handout_attributes] = {}
    end
  end

end
