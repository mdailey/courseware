require 'test_helper'

class DocumentFileTest < ActiveSupport::TestCase

  def test_should_create_document_file
    assert_difference 'DocumentFile.count' do
      a = create_document_file
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_attachable
    assert_no_difference 'DocumentFile.count' do
      a = create_document_file(:attachable_id => 10)
      assert a.errors.on(:attachable)
    end
  end
  
  def test_should_find_assignment_file
    assert_not_nil Course.find(1).assignments.first.document_file
  end

  private
  
  def create_document_file(options = {})
    record = DocumentFile.new({ :attachable_id => 2, :attachable_type => 'Assignment', :data => 'xxx' }.merge(options))
    record.save
    record
  end
end
