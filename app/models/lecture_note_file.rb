class LectureNoteFile < ActiveRecord::Base
  belongs_to :lecture_note
  validates_presence_of :lecture_note
end
