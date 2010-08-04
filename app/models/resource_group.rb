class ResourceGroup < ActiveRecord::Base
  has_many :resources
  has_many :course_resources
end
