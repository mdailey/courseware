class AddUserIdIndexToPeople < ActiveRecord::Migration
  def self.up
    add_index :people, :user_id
  end

  def self.down
    remove_index :people, :user_id
  end
end
