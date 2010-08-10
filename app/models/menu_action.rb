class MenuAction < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :course
  validates_uniqueness_of :order, :scope => :course_id
  validates_uniqueness_of :tag, :scope => :course_id
  validates_uniqueness_of :action, :scope => :course_id
end
