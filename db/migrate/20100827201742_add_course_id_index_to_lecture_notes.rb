class AddCourseIdIndexToLectureNotes < ActiveRecord::Migration
  def self.up
    add_index :lecture_notes, :course_id
  end

  def self.down
    remove_index :lecture_notes, :course_id
  end
end
