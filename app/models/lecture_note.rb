class LectureNote < ActiveRecord::Base
  belongs_to :course
  has_one :lecture_note_file
end
