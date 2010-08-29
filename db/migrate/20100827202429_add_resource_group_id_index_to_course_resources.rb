class AddResourceGroupIdIndexToCourseResources < ActiveRecord::Migration
  def self.up
    add_index :course_resources, :resource_group_id
  end

  def self.down
    remove_index :course_resources, :resource_group_id
  end
end
