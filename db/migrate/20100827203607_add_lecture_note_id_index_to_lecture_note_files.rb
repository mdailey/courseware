class AddLectureNoteIdIndexToLectureNoteFiles < ActiveRecord::Migration
  def self.up
    add_index :lecture_note_files, :lecture_note_id
  end

  def self.down
    remove_index :lecture_note_files, :lecture_note_id
  end
end
