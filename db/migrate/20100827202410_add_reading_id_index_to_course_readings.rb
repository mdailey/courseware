class AddReadingIdIndexToCourseReadings < ActiveRecord::Migration
  def self.up
    add_index :course_readings, :reading_id
  end

  def self.down
    remove_index :course_readings, :reading_id
  end
end
