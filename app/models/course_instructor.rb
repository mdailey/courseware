class CourseInstructor < ActiveRecord::Base
  belongs_to :course
  belongs_to :person
  
  validates_presence_of :course, :message => 'no course for instructor'
  validates_presence_of :person, :message => 'no person for instructor'

  validates_inclusion_of :role, :in => %w( main ta ), :message => 'invalid role for instructor'

end
