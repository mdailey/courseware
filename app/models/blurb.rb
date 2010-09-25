class Blurb < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :course
  
  def render_html
    if self.contents
      if self.contents.match(/^\w*</)
        self.contents
      else
        '<p>' + self.contents + '</p>'
      end
    else
      ''
    end
  end
  
end
