class Lecture < ActiveRecord::Base
  belongs_to :course
  has_many :lecture_dates
  validates_presence_of :course
  validates_uniqueness_of :number, :scope => :course_id

  def lecture_dates_string
    lecture_dates.sort {|d1,d2| d1.date <=> d2.date}.collect { |d| d.date.to_formatted_s(:rfc822) }.join('<br/>')
  end
  
  def lecture_dates_string=(dates)
    lecture_dates = [ dates.to_date ]
  end
end
