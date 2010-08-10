require 'test_helper'

class LectureNoteTest < ActiveSupport::TestCase
  fixtures :courses, :lecture_notes
  
  def test_should_create_lecture_note
    assert_difference 'LectureNote.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_course
    assert_no_difference 'LectureNote.count' do
      a = create_record(:course_id => 5)
      assert a.errors.on(:course)
    end
  end
  
  def test_should_require_unique_numbers
    assert_no_difference 'LectureNote.count' do
      a = create_record(:course_id => 1, :number => 1)
      assert a.errors.on(:number)
    end
  end
  
  def test_should_find_lecture_notes
    assert Course.find(1).lecture_notes.size == 2
  end

  private
  
  def create_record(options = {})
    record = LectureNote.new({ :course_id => 2, :number => 1,
                               :topic => 'Geometry', :file_label => 'PDF',
                               :file_name => 'syllabus.pdf' }.merge(options))
    record.save
    record
  end
end
