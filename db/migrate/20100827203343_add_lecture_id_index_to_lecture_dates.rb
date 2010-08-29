class AddLectureIdIndexToLectureDates < ActiveRecord::Migration
  def self.up
    add_index :lecture_dates, :lecture_id
  end

  def self.down
    remove_index :lecture_dates, :lecture_id
  end
end
