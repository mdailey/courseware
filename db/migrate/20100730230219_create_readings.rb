class CreateReadings < ActiveRecord::Migration
  def self.up
    create_table :readings do |t|
      t.string :title
      t.string :authors
      t.string :image_url
      t.string :sales_info_url
      t.string :edition
      t.string :publisher
      t.integer :year
      t.string :isbn
      t.string :note
      t.string :bib_info

      t.timestamps
    end
  end

  def self.down
    drop_table :readings
  end
end
