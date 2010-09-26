class LectureNote < ActiveRecord::Base
  belongs_to :course
  has_one :document_file, :as => :attachable, :autosave => true, :dependent => :destroy

  validates_presence_of :course
  validates_uniqueness_of :number, :scope => :course_id

  def document_info
    return file_name, file_label, document_file ? document_file.data : nil
  end

  def self.post_from_attributes(course, new_attributes)
    new_attributes.each do |attributes|
      document_file = nil
      if attributes[:document_file]
        attributes[:file_name] = attributes[:document_file].original_filename
        file_data = attributes[:document_file].read
        attributes[:document_file].delete
        attributes.delete(:document_file)
        document_file = DocumentFile.new
        document_file.data = Base64.encode64 file_data
      end
      if (attributes[:number] and attributes[:number].length) > 0 or
         (attributes[:topic] and attributes[:topic].length > 0)
        course.lecture_notes.build(attributes)
        if document_file
          lecture_note = course.lecture_notes.select {|h| h.new_record?}.first
          lecture_note.document_file = document_file
          lecture_note.document_file.attachable = lecture_note
        end
      end
    end
  end

  def self.update_from_attributes(course, lecture_note_attributes)
    course.lecture_notes.reject(&:new_record?).each do |lecture_note|
      attributes = lecture_note_attributes[lecture_note.id.to_s]
      if attributes
        file_data = nil
        if attributes[:document_file]
          attributes[:file_name] = attributes[:document_file].original_filename
          file_data = attributes[:document_file].read
          attributes[:document_file].delete
          attributes.delete(:document_file)
        end
        lecture_note.attributes = attributes
        if file_data
          if !lecture_note.document_file
            lecture_note.document_file = DocumentFile.new
            lecture_note.document_file.attachable = lecture_note
          end
          lecture_note.document_file.data = Base64.encode64 file_data
        end  
      else
        course.lecture_notes.delete(lecture_note)
      end
    end
  end
  
end
