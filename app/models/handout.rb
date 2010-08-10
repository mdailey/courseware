class Handout < ActiveRecord::Base
  has_one :handout_file
  belongs_to :course
  validates_presence_of :course
  validates_uniqueness_of :number, :scope => :course_id
end
