require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
  fixtures :courses, :announcements
  
  def test_should_create_announcement
    assert_difference 'Announcement.count' do
      a = create_announcement
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_course
    assert_no_difference 'Announcement.count' do
      a = create_announcement(:course_id => 5)
      assert a.errors.on(:course)
    end
  end
  
  def test_should_find_announcements
    assert Course.find(1).announcements.size == 2
  end

  private
  
  def create_announcement(options = {})
    record = Announcement.new({ :course_id => 2, :date => '2010-08-10',
                                :text => 'Announcement' }.merge(options))
    record.save
    record
  end
end
