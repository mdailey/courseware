class HandoutFile < ActiveRecord::Base
  belongs_to :handout
  validates_presence_of :handout
end
