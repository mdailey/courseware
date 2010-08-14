require 'test_helper'

class LectureTest < ActiveSupport::TestCase
 
  def test_should_create_lecture
    assert_difference 'Lecture.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_course
    assert_no_difference 'Lecture.count' do
      a = create_record(:course_id => 5)
      assert a.errors.on(:course)
    end
  end
  
  def test_should_allow_nonunique
    assert_difference 'Lecture.count' do
      a = create_record(:course_id => 1, :number => 1)
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_find_lectures
    assert Course.find(1).lectures.size == 2
  end

  private
  
  def create_record(options = {})
    record = Lecture.new({ :course_id => 2,
                           :number => 1, :topics => 'XXX',
                           :readings => 'YYY' }.merge(options))
    record.save
    record
  end
end
