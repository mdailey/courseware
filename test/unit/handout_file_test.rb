require 'test_helper'

class HandoutFileTest < ActiveSupport::TestCase
  fixtures :courses, :handouts, :handout_files
  
  def test_should_create_handout_file
    assert_difference 'HandoutFile.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_handout
    assert_no_difference 'HandoutFile.count' do
      a = create_record(:handout_id => 10)
      assert a.errors.on(:handout)
    end
  end
  
  def test_should_find_handout_file
    assert_not_nil Course.find(1).handouts.first.handout_file
  end

  private
  
  def create_record(options = {})
    record = HandoutFile.new({ :handout_id => 2, :file_data => 'xxx' }.merge(options))
    record.save
    record
  end
end
