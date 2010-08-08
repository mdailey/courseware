class Person < ActiveRecord::Base
  has_many :course_instructors
  has_many :courses, :through => :course_instructors
  
  validates_length_of :firstname, :minimum => 1
  validates_length_of :lastname, :minimum => 1
  validates_uniqueness_of :firstname, :scope => :lastname
  
  def name
    firstname + ' ' + lastname
  end
end
