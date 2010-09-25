class Assignment < ActiveRecord::Base
  belongs_to :course
  has_one :document_file, :as => :attachable, :autosave => true, :dependent => :destroy

  validates_presence_of :course
  validates_uniqueness_of :number, :scope => :course_id

  def document_info
    return ps_fname, ps_flabel, document_file ? document_file.data : nil
  end

end
