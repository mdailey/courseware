class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.integer :resource_group_id
      t.text :link

      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
