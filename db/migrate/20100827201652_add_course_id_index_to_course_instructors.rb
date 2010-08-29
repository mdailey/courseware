class AddCourseIdIndexToCourseInstructors < ActiveRecord::Migration
  def self.up
    add_index :course_instructors, :course_id
  end

  def self.down
    remove_index :course_instructors, :course_id
  end
end
