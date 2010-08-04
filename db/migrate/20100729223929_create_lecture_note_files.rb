class CreateLectureNoteFiles < ActiveRecord::Migration
  def self.up
    create_table :lecture_note_files do |t|
      t.integer :lecture_note_id
      t.binary :file_data

      t.timestamps
    end
  end

  def self.down
    drop_table :lecture_note_files
  end
end
