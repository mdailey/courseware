require 'test_helper'

class AssignmentFileTest < ActiveSupport::TestCase
  fixtures :courses, :assignments, :assignment_files
  
  def test_should_create_assignment_file
    assert_difference 'AssignmentFile.count' do
      a = create_assignment_file
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_assignment
    assert_no_difference 'AssignmentFile.count' do
      a = create_assignment_file(:assignment_id => 10)
      assert a.errors.on(:assignment)
    end
  end
  
  def test_should_find_assignment_file
    assert_not_nil Course.find(1).assignments.first.assignment_file
  end

  private
  
  def create_assignment_file(options = {})
    record = AssignmentFile.new({ :assignment_id => 2, :file_data => 'xxx' }.merge(options))
    record.save
    record
  end
end
