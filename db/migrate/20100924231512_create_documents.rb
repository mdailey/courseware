class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :document_files do |t|
      t.integer :attachable_id
      t.string :attachable_type
      t.binary :data
      t.timestamps
    end
  end

  def self.down
    drop_table :document_files
  end
end
