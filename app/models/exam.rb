class Exam < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :course
  validates_uniqueness_of :number, :scope => :course_id
end
