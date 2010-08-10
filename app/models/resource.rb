class Resource < ActiveRecord::Base
  belongs_to :resource_group
  validates_presence_of :resource_group
end
