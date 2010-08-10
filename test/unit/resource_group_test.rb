require 'test_helper'

class ResourceGroupTest < ActiveSupport::TestCase
  fixtures :resource_groups

  def test_should_create_resource_group
    assert_difference 'ResourceGroup.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_title
    assert_no_difference 'ResourceGroup.count' do
      a = create_record(:title => nil)
      assert a.errors.on(:title)
    end
  end
  
  def test_should_require_unique_title
    assert_no_difference 'ResourceGroup.count' do
      a = create_record(:title => resource_groups(:one).title)
      assert a.errors.on(:title)
    end
  end
  
  private
  
  def create_record(options = {})
    record = ResourceGroup.new({ :title => 'XXX' }.merge(options))
    record.save
    record
  end
end
