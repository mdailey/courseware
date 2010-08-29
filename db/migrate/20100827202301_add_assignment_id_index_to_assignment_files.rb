class AddAssignmentIdIndexToAssignmentFiles < ActiveRecord::Migration
  def self.up
    add_index :assignment_files, :assignment_id
  end

  def self.down
    remove_index :assignment_files, :assignment_id
  end
end
