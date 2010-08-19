class Assignment < ActiveRecord::Base
  belongs_to :course
  has_one :assignment_file, :autosave => true, :dependent => :destroy
  
  validates_presence_of :course
  validates_uniqueness_of :number, :scope => :course_id
end
