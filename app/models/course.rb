class Course < ActiveRecord::Base
  has_many :menu_actions, :autosave => true, :dependent => :destroy
  has_many :lectures, :autosave => true, :dependent => :destroy
  has_many :announcements, :autosave => true, :dependent => :destroy
  has_many :blurbs, :autosave => true, :dependent => :destroy
  has_many :course_instructors, :autosave => true, :dependent => :destroy
  has_many :instructors, :through => :course_instructors, :source => :person
  has_many :lecture_notes, :autosave => true, :dependent => :destroy
  has_many :handouts, :autosave => true, :dependent => :destroy
  has_many :course_readings, :autosave => true, :dependent => :destroy
  has_many :readings, :through => :course_readings
  has_many :course_resources, :autosave => true, :dependent => :destroy
  has_many :resource_groups, :through => :course_resources
  has_many :exams, :autosave => true, :dependent => :destroy
  has_many :assignments, :autosave => true, :dependent => :destroy
  
  validates_presence_of :year
  validates_presence_of :semester
  validates_presence_of :name
  validates_presence_of :code

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
    course_readings.reject(&:new_record?).each do |course_reading|
      attributes = course_reading_attributes[course_reading.id.to_s]
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

  def new_handout_attributes=(handout_attributes)
    handout_attributes.each do |attributes|
      handout_file = nil
      if attributes[:handout_file]
        attributes[:file_name] = attributes[:handout_file].original_filename
        file_data = attributes[:handout_file].read
        attributes[:handout_file].delete
        attributes.delete(:handout_file)
        handout_file = HandoutFile.new
        handout_file.file_data = Base64.encode64 file_data
      end
      if (attributes[:number] and attributes[:number].length) > 0 or
         (attributes[:topic] and attributes[:topic].length > 0)
        handouts.build(attributes)
        if handout_file
          handout = handouts.select {|h| h.new_record?}.first
          handout.handout_file = handout_file
          handout.handout_file.handout = handout
        end
      end
    end
  end
   
  def new_lecture_note_attributes=(new_attributes)
    new_attributes.each do |attributes|
      lecture_note_file = nil
      if attributes[:lecture_note_file]
        attributes[:file_name] = attributes[:lecture_note_file].original_filename
        file_data = attributes[:lecture_note_file].read
        attributes[:lecture_note_file].delete
        attributes.delete(:lecture_note_file)
        lecture_note_file = LectureNoteFile.new
        lecture_note_file.file_data = Base64.encode64 file_data
      end
      if (attributes[:number] and attributes[:number].length) > 0 or
         (attributes[:topic] and attributes[:topic].length > 0)
        lecture_notes.build(attributes)
        if lecture_note_file
          lecture_note = lecture_notes.select {|h| h.new_record?}.first
          lecture_note.lecture_note_file = lecture_note_file
          lecture_note.lecture_note_file.lecture_note = lecture_note
        end
      end
    end
  end

  def new_assignment_attributes=(new_attributes)
    new_attributes.each do |attributes|
      assignment_file = nil
      if attributes[:assignment_file]
        attributes[:ps_fname] = attributes[:assignment_file].original_filename
        file_data = attributes[:assignment_file].read
        attributes[:assignment_file].delete
        attributes.delete(:assignment_file)
        assignment_file = AssignmentFile.new
        assignment_file.file_data = Base64.encode64 file_data
      end
      if attributes[:document_file]
        attributes[:ps_fname] = attributes[:document_file].original_filename
        file_data = attributes[:document_file].read
        attributes[:document_file].delete
        attributes.delete(:document_file)
        document_file = DocumentFile.new
        document_file.data = Base64.encode64 file_data
      end
      if (attributes[:number] and attributes[:number].length) > 0 or
         (attributes[:title] and attributes[:title].length > 0)
        assignments.build(attributes)
        if assignment_file
          assignment = assignments.select {|h| h.new_record?}.first
          assignment.assignment_file = assignment_file
          assignment.assignment_file.assignment = assignment
        end
        if document_file
          assignment = assignments.select {|h| h.new_record?}.first
          assignment.document_file = document_file
          assignment.document_file.attachable = assignment
        end
      end
    end
  end
  
  def existing_handout_attributes=(handout_attributes)
    handouts.reject(&:new_record?).each do |handout|
      attributes = handout_attributes[handout.id.to_s]
      if attributes
        file_data = nil
        if attributes[:handout_file]
          attributes[:file_name] = attributes[:handout_file].original_filename
          file_data = attributes[:handout_file].read
          attributes[:handout_file].delete
          attributes.delete(:handout_file)
        end
        handout.attributes = attributes
        if file_data
          if !handout.handout_file
            handout.handout_file = HandoutFile.new
            handout.handout_file.handout = handout
          end
          handout.handout_file.file_data = Base64.encode64 file_data
        end  
      else
        handouts.delete(handout)
      end
    end
  end
  
  def existing_lecture_note_attributes=(lecture_note_attributes)
    lecture_notes.reject(&:new_record?).each do |lecture_note|
      attributes = lecture_note_attributes[lecture_note.id.to_s]
      if attributes
        file_data = nil
        if attributes[:lecture_note_file]
          attributes[:file_name] = attributes[:lecture_note_file].original_filename
          file_data = attributes[:lecture_note_file].read
          attributes[:lecture_note_file].delete
          attributes.delete(:lecture_note_file)
        end
        lecture_note.attributes = attributes
        if file_data
          if !lecture_note.lecture_note_file
            lecture_note.lecture_note_file = LectureNoteFile.new
            lecture_note.lecture_note_file.lecture_note = lecture_note
          end
          lecture_note.lecture_note_file.file_data = Base64.encode64 file_data
        end  
      else
        lecture_notes.delete(lecture_note)
      end
    end
  end
  
  def existing_assignment_attributes=(assignment_attributes)
    assignments.reject(&:new_record?).each do |assignment|
      attributes = assignment_attributes[assignment.id.to_s]
      if attributes
        file_data = nil
        if attributes[:assignment_file]
          attributes[:ps_fname] = attributes[:assignment_file].original_filename
          file_data = attributes[:assignment_file].read
          attributes[:assignment_file].delete
          attributes.delete(:assignment_file)
        end
        if attributes[:document_file]
          attributes[:ps_fname] = attributes[:document_file].original_filename
          file_data = attributes[:document_file].read
          attributes[:document_file].delete
          attributes.delete(:document_file)
        end
        assignment.attributes = attributes
        if file_data
          if !assignment.document_file
            assignment.document_file = DocumentFile.new
            assignment.document_file.assignment = assignment
          end
          assignment.document_file.data = Base64.encode64 file_data
        end  
      else
        assignments.delete(assignment)
      end
    end
  end
  
  def save_course_instructors
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
    bNew = blurbs.build(attributes)
    logger.debug "bnew: #{bNew.inspect}"
    if bOld and bOld.contents != bNew.contents
      blurbs.delete(bOld)
    end
    if !bOld or bOld.contents != bNew.contents
      bNew.course_page = course_page
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
  
  def handouts_blurb=(attributes)
    update_blurb('handouts',attributes)
  end
  
  def lecture_notes_blurb=(attributes)
    update_blurb('lecture_notes',attributes)
  end
  
  def assignments_blurb=(attributes)
    update_blurb('assignments',attributes)
  end
  
  def lectures_blurb=(attributes)
    update_blurb('lectures',attributes)
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
  
  def user_authorized_for?(user, action)
    return true if action == :show or action == :static
    return true if user and user.has_role? :admin
    return false if action != :edit
    user and instructors.select { |i| i.user_id == user.id }.size > 0
  end
  
  def clone_associations!(course)
    Course.transaction do
      self.save
      self.menu_actions = course.menu_actions.collect { |ma| ma.clone }
      self.blurbs = course.blurbs.collect { |b| b.clone }
      self.course_instructors = course.course_instructors.collect { |ci| ci.clone }
      self.course_readings = course.course_readings.collect { |cr| cr.clone }
      self.course_resources = course.course_resources.collect { |cr| cr.clone }
      self.exams = course.exams.collect { |e| e.clone }
      self.save
    end
  end
  
  def set_date
    time = Time.now
    self.semester = Date::MONTHNAMES[time.month]
    self.year = time.year
  end
  
  def title
    if self.code and self.name and self.semester and self.year
      self.code + ': ' + self.name + ', ' + self.semester + ' ' + self.year.to_s
    else
      'New course'
    end
  end


end
