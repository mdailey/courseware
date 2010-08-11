require 'test_helper'

class BlurbTest < ActiveSupport::TestCase
  
  def test_should_create_blurb
    assert_difference 'Blurb.count' do
      b = create_blurb
      assert !b.new_record?, "#{b.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_course
    assert_no_difference 'Blurb.count' do
      b = create_blurb(:course_id => 5)
      assert b.errors.on(:course)
    end
  end
  
  def test_should_find_blurbs
    assert_not_nil Course.find(1).blurb('lecture_notes').contents
    assert_not_nil Course.find(1).blurb('lectures').contents
    assert_not_nil Course.find(1).blurb('handouts').contents
    assert_not_nil Course.find(1).blurb('readings').contents
    assert_not_nil Course.find(1).blurb('resources').contents
    assert_not_nil Course.find(1).blurb('exams').contents
    assert_not_nil Course.find(1).blurb('assignments').contents
  end

  private
  
  def create_blurb(options = {})
    record = Blurb.new({ :course_id => 2, :course_page => 'lecture_notes',
                         :contents => 'Lecture notes blurb' }.merge(options))
    record.save
    record
  end

end