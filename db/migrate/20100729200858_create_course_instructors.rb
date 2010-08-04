class CreateCourseInstructors < ActiveRecord::Migration
  def self.up
    create_table :course_instructors do |t|
      t.integer :course_id
      t.integer :person_id
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :course_instructors
  end
end
