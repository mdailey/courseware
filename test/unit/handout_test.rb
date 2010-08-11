require 'test_helper'

class HandoutTest < ActiveSupport::TestCase
  
  def test_should_create_handout
    assert_difference 'Handout.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_course
    assert_no_difference 'Handout.count' do
      a = create_record(:course_id => 5)
      assert a.errors.on(:course)
    end
  end
  
  def test_should_require_unique_numbers
    assert_no_difference 'Handout.count' do
      a = create_record(:course_id => 1, :number => 1)
      assert a.errors.on(:number)
    end
  end
  
  def test_should_find_handout
    assert Course.find(1).handouts.size == 2
  end

  private
  
  def create_record(options = {})
    record = Handout.new({ :course_id => 2, :number => 1,
                           :topic => 'Syllabus', :file_label => 'PDF',
                           :file_name => 'syllabus.pdf' }.merge(options))
    record.save
    record
  end
end
