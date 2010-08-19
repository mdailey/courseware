class Handout < ActiveRecord::Base
  has_one :handout_file, :autosave => true, :dependent => :destroy
  belongs_to :course
  validates_presence_of :course, :number, :topic, :file_label, :handout_file
  validates_uniqueness_of :number, :scope => :course_id
end
