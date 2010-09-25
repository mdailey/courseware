class DocumentFile < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  validates_presence_of :attachable
end
