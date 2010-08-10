class Course < ActiveRecord::Base
  has_many :menu_actions
  has_many :lectures
  has_many :announcements
  has_many :blurbs
  has_many :course_instructors, :autosave => true
  has_many :instructors, :through => :course_instructors, :source => :person
  has_many :lecture_notes
  has_many :handouts
  has_many :course_readings
  has_many :readings, :through => :course_readings
  has_many :course_resources
  has_many :resource_groups, :through => :course_resources
  has_many :exams
  has_many :assignments
  
  validates_associated :course_instructors
  validates_presence_of :year
  validates_presence_of :semester

  def new_course_reading_attributes=(course_reading_attributes)
    course_reading_attributes.each do |attributes|
      reading_attributes = attributes[:reading]
      attributes[:reading] = nil
      if reading_attributes and reading_attributes[:title] and reading_attributes[:title].length > 0
        r = Reading.find_by_title_and_edition(reading_attributes[:title],reading_attributes[:edition])
        if !r
          r = Reading.new(reading_attributes)
          r.save
        end
        if r and r.id
          attributes[:reading_id] = r.id.to_s
        end
      end
      if attributes[:reading_id] and attributes[:reading_id].length > 0
        course_readings.build(attributes)
      end
    end
  end
   
  def new_course_instructor_attributes=(course_instructor_attributes)
    course_instructor_attributes.each do |attributes|
      person_attributes = attributes[:person]
      attributes[:person] = nil
      if person_attributes and person_attributes[:lastname] and person_attributes[:lastname].length > 0
        p = Person.find_by_firstname_and_lastname(person_attributes[:firstname],person_attributes[:lastname])
        if !p
          p = Person.new(person_attributes)
          p.save
        end
        if p and p.id
          attributes[:person_id] = p.id.to_s
        end
      end
      if attributes[:person_id] and attributes[:person_id].length > 0
        course_instructors.build(attributes)
      end
    end
    course_instructors.each { |ci| ci.course = self }
  end

  def existing_course_reading_attributes=(course_reading_attributes)
    logger.debug "Course reading attributes: #{course_reading_attributes}"
    course_readings.reject(&:new_record?).each do |course_reading|
      attributes = course_reading_attributes[course_reading.id.to_s]
      logger.debug "  attributes: #{attributes}"
      if attributes
        course_reading.attributes = attributes
      else
        course_readings.delete(course_reading)
      end
    end
  end
  
  def existing_course_instructor_attributes=(course_instructor_attributes)
    course_instructors.reject(&:new_record?).each do |course_instructor|
      attributes = course_instructor_attributes[course_instructor.id.to_s]
      if attributes
        course_instructor.attributes = attributes
      else
        course_instructors.delete(course_instructor)
      end
    end
  end

  def save_course_instructors
    logger.debug "Saving"
    logger.debug course_instructors.inspect
    course_instructors.each do |course_instructor|
      course_instructor.save(false)
    end
  end
    
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
    blurbs.select {|b| b.course_page == course_page}.first
  end
  
  def update_blurb(course_page,attributes)
    bOld = blurb(course_page)
    bNew = Blurb.new(attributes)
    if bOld and bOld.contents != bNew.contents
      blurbs.delete(bOld)
    end
    if !bOld or bOld.contents != bNew.contents
      bNew.course_page = course_page
      bNew.course_id = id
      bNew.save
    end
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
  
  def readings_blurb=(attributes)
    update_blurb('readings',attributes)
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
