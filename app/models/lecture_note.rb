class LectureNote < ActiveRecord::Base
  belongs_to :course
  has_one :lecture_note_file
  validates_presence_of :course
  validates_uniqueness_of :number, :scope => :course_id
end
