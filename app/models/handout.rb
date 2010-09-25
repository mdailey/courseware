class Handout < ActiveRecord::Base
  belongs_to :course
  has_one :document_file, :as => :attachable, :autosave => true, :dependent => :destroy

  validates_presence_of :course, :number, :topic, :file_label, :document_file
  validates_uniqueness_of :number, :scope => :course_id

  def document_info
    return file_name, file_label, document_file ? document_file.data : nil
  end

end
