class CreateExams < ActiveRecord::Migration
  def self.up
    create_table :exams do |t|
      t.integer :course_id
      t.integer :number
      t.string :title
      t.string :place
      t.string :date

      t.timestamps
    end
  end

  def self.down
    drop_table :exams
  end
end
