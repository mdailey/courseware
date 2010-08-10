require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  fixtures :resource_groups, :resources
  
  def test_should_create_resource
    assert_difference 'Resource.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_resource_group
    assert_no_difference 'Resource.count' do
      a = create_record(:resource_group_id => 5)
      assert a.errors.on(:resource_group)
    end
  end
  
  def test_should_find_resources
    assert ResourceGroup.find(1).resources.size == 2
  end

  private
  
  def create_record(options = {})
    record = Resource.new({ :resource_group_id => 2, :link => 'XXX' }.merge(options))
    record.save
    record
  end
end
