class CourseResource < ActiveRecord::Base
  belongs_to :course
  belongs_to :resource_group
  validates_presence_of :course
  validates_presence_of :resource_group
end
