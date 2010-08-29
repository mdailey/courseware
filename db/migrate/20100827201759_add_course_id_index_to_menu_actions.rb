class AddCourseIdIndexToMenuActions < ActiveRecord::Migration
  def self.up
    add_index :menu_actions, :course_id
  end

  def self.down
    remove_index :menu_actions, :course_id
  end
end
