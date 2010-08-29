class AddCourseIdIndexToExams < ActiveRecord::Migration
  def self.up
    add_index :exams, :course_id
  end

  def self.down
    remove_index :exams, :course_id
  end
end
