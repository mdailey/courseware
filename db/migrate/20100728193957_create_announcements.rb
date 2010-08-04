class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.integer :course_id
      t.date :date
      t.text :text

      t.timestamps
    end
  end

  def self.down
    drop_table :announcements
  end
end
