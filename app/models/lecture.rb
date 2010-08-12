class Lecture < ActiveRecord::Base
  belongs_to :course
  has_many :lecture_dates
  validates_presence_of :course
  validates_uniqueness_of :number, :scope => :course_id
end
