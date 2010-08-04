module ApplicationHelper
  
  def course_title( course )
    if course.code and course.name and course.semester and course.year
      course.code + ': ' + course.name + ', ' + course.semester + ' ' + course.year.to_s
    else
      'New course'
    end
  end
  
  def render_blurb( blurb )
    if blurb and blurb.match /^\w*</
      sanitize @blurb
    elsif blurb
      '<p>' + sanitize( blurb ) + '</p>'
    else
      ''
    end
  end
  
end
