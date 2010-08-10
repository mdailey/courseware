require 'test_helper'

class CourseResourceTest < ActiveSupport::TestCase
  fixtures :courses, :resource_groups, :resources, :course_resources
  
  def test_should_create_course_resource
    assert_difference 'CourseResource.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_course_and_resource_group
    assert_no_difference 'CourseResource.count' do
      a = create_record(:course_id => 5)
      assert a.errors.on(:course)
      a = create_record(:resource_group_id => 5)
      assert a.errors.on(:resource_group)
    end
  end
  
  def test_should_find_resource_groups
    assert Course.find(1).resource_groups.size == 2
  end

  private
  
  def create_record(options = {})
    record = CourseResource.new({ :course_id => 2, :resource_group_id => 1 }.merge(options))
    record.save
    record
  end
end
