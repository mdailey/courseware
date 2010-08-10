require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  fixtures :courses

  def test_should_create_course
    assert_difference 'Course.count' do
      course = create_course
      assert !course.new_record?, "#{course.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_year
    assert_no_difference 'Course.count' do
      c = create_course(:year => nil)
      assert c.errors.on(:year)
    end
  end
  
  def test_should_require_name
    assert_no_difference 'Course.count' do
      c = create_course(:name => nil)
      assert c.errors.on(:name)
    end
  end

  def test_should_require_semester
    assert_no_difference 'Course.count' do
      c = create_course(:semester => nil)
      assert c.errors.on(:semester)
    end
  end

  def test_should_require_code
    assert_no_difference 'Course.count' do
      c = create_course(:code => nil)
      assert c.errors.on(:code)
    end
  end

  private
  
  def create_course(options = {})
    record = Course.new({ :name => 'New course', :code => 'CS101',
                          :rooms => 'CS 102', :days_times => 'MW 10-11',
                          :description => 'Blah blah', :year => 2010,
                          :semester => 'August' }.merge(options))
    record.save
    record
  end
end
