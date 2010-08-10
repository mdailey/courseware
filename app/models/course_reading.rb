class CourseReading < ActiveRecord::Base
  belongs_to :course
  belongs_to :reading
  validates_presence_of :course
  validates_presence_of :reading
end
