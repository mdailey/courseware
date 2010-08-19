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
      a = create_record({:course_id => 5, :number => nil, :topic => nil, :file_label => nil})
      assert a.errors.on(:course)
      assert a.errors.on(:number)
      assert a.errors.on(:topic)
      assert a.errors.on(:file_label)
    end
  end
  
  def test_should_require_unique_numbers
    assert_no_difference 'Handout.count' do
      a = create_record({:course_id => 1, :number => 1})
      assert a.errors.on(:number)
    end
  end
  
  def test_should_require_handout_file
    assert_no_difference 'Handout.count' do
      a = create_record({},false)
      assert a.errors.on(:handout_file)
    end
  end
  
  def test_should_find_handout
    assert Course.find(1).handouts.size == 2
  end

  private
  
  def create_record(options = {},create_handout_file = true)
    record = Handout.new({ :course_id => 2, :number => 1,
                           :topic => 'Syllabus', :file_label => 'PDF',
                           :file_name => 'syllabus.pdf' }.merge(options))
    if create_handout_file
      record.handout_file = HandoutFile.new
      record.handout_file.handout = record
      record.handout_file.file_data = 'abcdefg'
    end
    record.save
    record
  end
end
