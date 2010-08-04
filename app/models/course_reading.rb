class CourseReading < ActiveRecord::Base
  belongs_to :course
  belongs_to :reading
end
