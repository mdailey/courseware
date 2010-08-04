class CreateAssignmentFiles < ActiveRecord::Migration
  def self.up
    create_table :assignment_files do |t|
      t.integer :assignment_id
      t.binary :file_data

      t.timestamps
    end
  end

  def self.down
    drop_table :assignment_files
  end
end
