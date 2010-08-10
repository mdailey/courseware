require 'test_helper'

class ExamTest < ActiveSupport::TestCase
  fixtures :courses, :exams
  
  def test_should_create_exam
    assert_difference 'Exam.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_course
    assert_no_difference 'Exam.count' do
      a = create_record(:course_id => 5)
      assert a.errors.on(:course)
    end
  end
  
  def test_should_require_unique_numbers
    assert_no_difference 'Exam.count' do
      a = create_record(:course_id => 1, :number => 1)
      assert a.errors.on(:number)
    end
  end

  def test_should_find_exams
    assert Course.find(1).exams.size == 2
  end

  private
  
  def create_record(options = {})
    record = Exam.new({ :course_id => 2, :number => 1, :title => 'Final',
                        :place => 'CS 101', :date => '2010-08-10' }.merge(options))
    record.save
    record
  end
end
