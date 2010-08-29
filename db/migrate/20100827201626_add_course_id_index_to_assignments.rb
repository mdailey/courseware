class AddCourseIdIndexToAssignments < ActiveRecord::Migration
  def self.up
    add_index :assignments, :course_id
  end

  def self.down
    remove_index :assignments, :course_id
  end
end
