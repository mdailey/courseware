require 'test_helper'

class CourseReadingTest < ActiveSupport::TestCase
  
  def test_should_create_course_reading
    assert_difference 'CourseReading.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_course_and_reading
    assert_no_difference 'CourseReading.count' do
      a = create_record(:course_id => 5)
      assert a.errors.on(:course)
      a = create_record(:reading_id => 5)
      assert a.errors.on(:reading)
    end
  end
  
  def test_should_find_readings
    assert Course.find(1).readings.size == 2
  end

  private
  
  def create_record(options = {})
    record = CourseReading.new({ :course_id => 2, :reading_id => 1,
                                 :required => false }.merge(options))
    record.save
    record
  end
end
