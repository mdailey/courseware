module ApplicationHelper
  
  def course_title(course)
    if course.code and course.name and course.semester and course.year
      course.code + ': ' + course.name + ', ' + course.semester + ' ' + course.year.to_s
    else
      'New course'
    end
  end

  def render_blurb(blurb)
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
  
  def render_blurb_edit_form(course_page, blurb)
    form_fields = ""
    fields_for "course[#{course_page}_blurb]", blurb do |blurb_form|
      form_fields = %Q(
        <table>
          <tr>
            <td>#{blurb_form.label :contents, 'Blurb'}</td>
            <td>#{blurb_form.text_area :contents, :size => "40x3"}</td>
          </tr>
        </table>
      )
    end
    form_fields
  end
  
end
