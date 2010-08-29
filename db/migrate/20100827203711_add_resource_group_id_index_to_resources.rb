class AddResourceGroupIdIndexToResources < ActiveRecord::Migration
  def self.up
    add_index :resources, :resource_group_id
  end

  def self.down
    remove_index :resources, :resource_group_id
  end
end
