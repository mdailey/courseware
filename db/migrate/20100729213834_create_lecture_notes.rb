class CreateLectureNotes < ActiveRecord::Migration
  def self.up
    create_table :lecture_notes do |t|
      t.integer :course_id
      t.integer :number
      t.string :topic
      t.string :file_label
      t.string :file_name

      t.timestamps
    end
  end

  def self.down
    drop_table :lecture_notes
  end
end
