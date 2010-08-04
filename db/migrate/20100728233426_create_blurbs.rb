class CreateBlurbs < ActiveRecord::Migration
  def self.up
    create_table :blurbs do |t|
      t.integer :course_id
      t.string :course_page
      t.text :contents

      t.timestamps
    end
  end

  def self.down
    drop_table :blurbs
  end
end
