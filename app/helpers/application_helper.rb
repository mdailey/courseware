module ApplicationHelper
  
  def render_blurb(blurb)
    sanitize blurb.render_html
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
