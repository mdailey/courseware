class LecturesController < ApplicationController
  
  require_role ['admin','instructor'], :for => [:update, :edit]

  before_filter :find_course
  before_filter :find_blurb, :only => [:index,:edit]

  def index
    @lectures = @course.lectures

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lectures }
    end
  end

  def edit
    if !@course.user_authorized_for?(current_user,:edit)
      access_denied
      return
    end
    
    setup_for_edit
    
    respond_to do |format|
      format.html
      format.json { render :json => @course_lectures.to_jqgrid_json([:id,:number,:lecture_dates_string,:topics,:readings], 
                                                         @page, @rows, @course_lectures.total_entries) }
    end
  end
     
  def update
    if !@course.user_authorized_for?(current_user,:edit)
      access_denied
      return
    end
    
    if params[:commit] == "Update blurb"
      respond_to do |format|
        if @course.update_attributes(params[:course])
          format.html { redirect_to(edit_course_lectures_path(@course), :notice => 'Blurb successfully updated.') }
          format.xml  { head :ok }
        else
          format.html do
            setup_for_edit
            render :action => "edit"
          end
          format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
        end
      end
      return
    elsif params[:oper] == "del"
      Lecture.find(params[:id]).destroy
    else
      lecture_params = { :number => params[:number], :lecture_dates_string => params[:lecture_dates_string], :topics => params[:topics],
                         :readings => params[:readings], :course_id => params[:course_id] }
      if params[:id] == "_empty"
        logger.debug "Processing update with parameters #{params.inspect}"
        lecture = Lecture.create(lecture_params)
        logger.debug "Created lecture #{lecture.inspect}"
        logger.debug "with lecture dates #{lecture.lecture_dates.inspect}"
      else
        logger.debug "Processing update with parameters #{params.inspect}"
        lecture = Lecture.find(params[:id])
        lecture.update_attributes(lecture_params)
      end
    end

    # If you need to display error messages
    err = ""
    if lecture
      lecture.errors.entries.each do |error|
        err << "<strong>#{error[0]}</strong> : #{error[1]}<br/>"
      end
    end

    render :text => "#{err}"
  end

  protected
  
  def find_course
    @course = Course.find(params[:course_id])
  end
      
  def find_blurb
    @blurb = @course.lectures_blurb
  end
    
  def setup_for_edit
    @use_jqgrid = true
    
    @page = params[:page]

    @rows = params[:rows]
    if !@rows || @rows.length == 0 || @rows.to_i <= 0
      if @course.lectures.count > 0
        @rows = @course.lectures.count
      else
        @rows = 20
      end
    end

    sidx = params[:sidx]
    if !sidx or sidx.length == 0
      sidx = "number"
    end

    sord = params[:sord]
    if !sord or sord.length == 0
      sord = "asc"
    end
 
    @course_lectures = @course.lectures.find(:all) do
      if params[:_search] == "true"
        number               == params[:number].to_i if params[:number].present?
        topics               =~ "%#{params[:topics]}%" if params[:topics].present?
        readings             =~ "%#{params[:readings]}%" if params[:readings].present?
      end
      paginate :page => @page, :rows => @rows
      order_by "#{sidx} #{sord}"
    end

  end

end
