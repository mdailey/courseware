class AddCourseIdIndexToLectures < ActiveRecord::Migration
  def self.up
    add_index :lectures, :course_id
  end

  def self.down
    remove_index :lectures, :course_id
  end
end
