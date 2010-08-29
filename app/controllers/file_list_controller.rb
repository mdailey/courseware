class FileListController < ApplicationController

  require_role 'admin', :for_all_except => [:index, :show]
  
  before_filter :find_course
  before_filter :find_file_list, :only => [:index, :edit]
  before_filter :find_blurb, :only => [:index, :edit]
  
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @file_list }
    end
  end
  
  def show
    set_file
    
    if @file_data and @file_name and @file_label
      send_data Base64.decode64( @file_data ), :filename => @file_name, :type => mimetype(@file_label)
    else
      raise 'No file data found for request'
    end
  end
  
  def edit
    @file_list.build
  end
  
  def update
    fix_attributes

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to(edit_path(@course), :notice => 'File list successfully updated.') }
        format.xml  { head :ok }
      else
        format.html do
          set_file_list
          if @file_list.select { |h| h.new_record? }.size == 0
            @file_list.build
          end
          render :action => "edit"
        end
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  protected
  
  def find_course
    @course = Course.find(params[:course_id])
  end
  
end