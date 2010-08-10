module ApplicationHelper
  
  def course_title( course )
    if course.code and course.name and course.semester and course.year
      course.code + ': ' + course.name + ', ' + course.semester + ' ' + course.year.to_s
    else
      'New course'
    end
  end
  
  def render_blurb( blurb )
    if blurb and blurb.contents
      if blurb.contents.match /^\w*</
        sanitize @blurb.contents
      else
        '<p>' + sanitize( blurb.contents ) + '</p>'
      end
    else
      ''
    end
  end
  
end
