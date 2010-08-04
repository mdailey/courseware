class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.integer :course_id
      t.integer :number
      t.integer :title
      t.string :ps_flabel
      t.string :ps_fname
      t.string :soln_flabel
      t.string :soln_fname

      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
