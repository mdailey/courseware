class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :name
      t.string :code
      t.string :rooms
      t.string :days_times
      t.text :description
      t.integer :year
      t.string :semester

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
