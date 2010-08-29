class AddPersonIdIndexToCourseInstructors < ActiveRecord::Migration
  def self.up
    add_index :course_instructors, :person_id
  end

  def self.down
    remove_index :course_instructors, :person_id
  end
end
