require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  def test_should_create_person
    assert_difference 'Person.count' do
      a = create_person
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_fields
    assert_no_difference 'Person.count' do
      a = create_person(:firstname => nil)
      assert a.errors.on(:firstname)
      a = create_person(:lastname => nil)
      assert a.errors.on(:lastname)
    end
  end
  
  def test_should_require_unique_names
    assert_no_difference 'Person.count' do
      a = create_person(:lastname => people(:janedoe).lastname, :firstname => people(:janedoe).firstname)
      assert a.errors.on(:firstname)
    end
  end

  
  private
  
  def create_person(options = {})
    record = Person.new({ :firstname => 'James', :lastname => 'Johnston' }.merge(options))
    record.save
    record
  end
end
