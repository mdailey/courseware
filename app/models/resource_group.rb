class ResourceGroup < ActiveRecord::Base
  has_many :resources
  has_many :course_resources
  validates_presence_of :title
  validates_uniqueness_of :title
end
