class LecturesController < ApplicationController
  require_role 'admin', :for_all_except => [:index]
  
  def index
    @course = Course.find(params[:course_id])
    @lectures = @course.lectures
    @blurb = @course.lectures_blurb

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lectures }
    end
  end

  def edit
    @course = Course.find(params[:course_id])
    @blurb = @course.lectures_blurb
    @use_jqgrid = true
    page = params[:page]
    rows = params[:rows]
    rows = 10.to_s if !rows or rows.to_i < 10
    
    @course_lectures = @course.lectures.find(:all) do
      if params[:_search] == "true"
        topics    =~ "%#{params[:topics]}%" if params[:topics].present?
        readings  =~ "%#{params[:readings]}%" if params[:readings].present?
      end
      paginate :page => page, :rows => rows
      order_by "#{params[:sidx]} #{params[:sord]}"
    end

    respond_to do |format|
      format.html
      format.json { render :json => @course_lectures.to_jqgrid_json([:id,:number,:lecture_dates_string,:topics,:readings], 
                                                         page, rows, @course_lectures.total_entries) }
    end
  end

  def update
    if params[:oper] == "del"
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

end
