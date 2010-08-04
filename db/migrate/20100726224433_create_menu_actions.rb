class CreateMenuActions < ActiveRecord::Migration
  def self.up
    create_table :menu_actions do |t|
      t.integer :course_id
      t.integer :order
      t.string :tag
      t.string :action
      t.string :path

      t.timestamps
    end
  end

  def self.down
    drop_table :menu_actions
  end
end
