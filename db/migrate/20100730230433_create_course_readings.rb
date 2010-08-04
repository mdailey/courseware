class CreateCourseReadings < ActiveRecord::Migration
  def self.up
    create_table :course_readings do |t|
      t.integer :course_id
      t.integer :reading_id
      t.boolean :required

      t.timestamps
    end
  end

  def self.down
    drop_table :course_readings
  end
end
