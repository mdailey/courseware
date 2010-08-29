class AddCourseIdIndexToAnnouncements < ActiveRecord::Migration
  def self.up
    add_index :announcements, :course_id
  end

  def self.down
    remove_index :announcements, :course_id
  end
end
