class CreateLectureDates < ActiveRecord::Migration
  def self.up
    create_table :lecture_dates do |t|
      t.integer :lecture_id
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :lecture_dates
  end
end
