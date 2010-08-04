class Course < ActiveRecord::Base
  has_many :menu_actions
  has_many :lectures
  has_many :announcements
  has_many :blurbs
  has_many :course_instructors
  has_many :instructors, :through => :course_instructors, :source => :person
  has_many :lecture_notes
  has_many :handouts
  has_many :course_readings
  has_many :readings, :through => :course_readings
  has_many :course_resources
  has_many :resource_groups, :through => :course_resources
  has_many :exams
  has_many :assignments
  
  def instructors_with_role(role)
     course_instructors.select {|ci| ci.role == role}.collect {|ci| ci.person}
  end
  
  def main_instructors
    instructors_with_role('main')
  end
  
  def tas
    instructors_with_role('ta')
  end
  
  def blurb(course_page)
    blurbs.select {|b| b.course_page == course_page}.collect {|b| b.contents}.first
  end
  
  def lectures_blurb
    blurb('lectures')
  end
  
  def lecture_notes_blurb
    blurb('lecture_notes')
  end
  
  def handouts_blurb
    blurb('handouts')
  end
  
  def readings_blurb
    blurb('readings')
  end
  
  def resources_blurb
    blurb('resources')
  end
  
  def exams_blurb
    blurb('exams')
  end
  
  def assignments_blurb
    blurb('assignments')
  end
  
end
