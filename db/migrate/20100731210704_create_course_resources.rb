class CreateCourseResources < ActiveRecord::Migration
  def self.up
    create_table :course_resources do |t|
      t.integer :course_id
      t.integer :resource_group_id
      t.integer :order

      t.timestamps
    end
  end

  def self.down
    drop_table :course_resources
  end
end
