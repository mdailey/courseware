class LectureDate < ActiveRecord::Base
  belongs_to :lecture
  validates_presence_of :lecture
end
