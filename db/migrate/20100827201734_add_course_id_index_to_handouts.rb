class AddCourseIdIndexToHandouts < ActiveRecord::Migration
  def self.up
    add_index :handouts, :course_id
  end

  def self.down
    remove_index :handouts, :course_id
  end
end
