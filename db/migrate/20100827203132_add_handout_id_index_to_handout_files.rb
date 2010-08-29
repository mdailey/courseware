class AddHandoutIdIndexToHandoutFiles < ActiveRecord::Migration
  def self.up
    add_index :handout_files, :handout_id
  end

  def self.down
    remove_index :handout_files, :handout_id
  end
end
