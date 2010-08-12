require 'test_helper'

class LectureDateTest < ActiveSupport::TestCase
  
  def test_should_create_record
    assert_difference 'LectureDate.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_lecture
    assert_no_difference 'LectureDate.count' do
      a = create_record(:lecture_id => 5)
      assert a.errors.on(:lecture)
    end
  end
  
  def test_should_find_lecture_dates
    assert Course.find(1).lectures.first.lecture_dates.size == 1
  end

  private
  
  def create_record(options = {})
    record = LectureDate.new({ :lecture_id => 2, :date => '2010-08-10' }.merge(options))
    record.save
    record
  end
end
