class AddCourseIdIndexToBlurbs < ActiveRecord::Migration
  def self.up
    add_index :blurbs, :course_id
  end

  def self.down
    remove_index :blubrs, :course_id
  end
end
