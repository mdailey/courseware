class Assignment < ActiveRecord::Base
  belongs_to :course
  has_one :assignment_file
end
