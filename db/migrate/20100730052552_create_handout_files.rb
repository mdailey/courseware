class CreateHandoutFiles < ActiveRecord::Migration
  def self.up
    create_table :handout_files do |t|
      t.integer :handout_id
      t.binary :file_data

      t.timestamps
    end
  end

  def self.down
    drop_table :handout_files
  end
end
