class Person < ActiveRecord::Base
  has_many :course_instructors
  has_many :courses, :through => :course_instructors
end
