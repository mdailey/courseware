class Reading < ActiveRecord::Base
  has_many :course_readings
  validates_presence_of :title
  validates_presence_of :authors
  validates_uniqueness_of :edition, :scope => :title
end
