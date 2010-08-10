require 'test_helper'

class LectureNoteFileTest < ActiveSupport::TestCase
  fixtures :courses, :lecture_notes, :lecture_note_files
  
  def test_should_create_lecture_note_file
    assert_difference 'LectureNoteFile.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_lecture_note
    assert_no_difference 'LectureNoteFile.count' do
      a = create_record(:lecture_note_id => 10)
      assert a.errors.on(:lecture_note)
    end
  end
  
  def test_should_find_lecture_note_file
    assert_not_nil Course.find(1).lecture_notes.first.lecture_note_file
  end

  private
  
  def create_record(options = {})
    record = LectureNoteFile.new({ :lecture_note_id => 2, :file_data => 'xxx' }.merge(options))
    record.save
    record
  end
end
