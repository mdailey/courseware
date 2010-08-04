class CreateLectures < ActiveRecord::Migration
  def self.up
    create_table :lectures do |t|
      t.integer :course_id
      t.integer :number
      t.text :topics
      t.text :readings

      t.timestamps
    end
  end

  def self.down
    drop_table :lectures
  end
end
