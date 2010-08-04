class Handout < ActiveRecord::Base
  has_one :handout_file
  belongs_to :course
end
