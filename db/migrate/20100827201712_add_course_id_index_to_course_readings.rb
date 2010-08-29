class AddCourseIdIndexToCourseReadings < ActiveRecord::Migration
  def self.up
    add_index :course_readings, :course_id
  end

  def self.down
    remove_index :course_readings, :course_id
  end
end
