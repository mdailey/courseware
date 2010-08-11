require 'test_helper'

class ReadingTest < ActiveSupport::TestCase

  def test_should_create_reading
    assert_difference 'Reading.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_fields
    assert_no_difference 'Reading.count' do
      a = create_record(:title => nil)
      assert a.errors.on(:title)
      a = create_record(:authors => nil)
      assert a.errors.on(:authors)
    end
  end
  
  def test_should_require_unique
    assert_no_difference 'Reading.count' do
      a = create_record(:title => readings(:one).title, :edition => readings(:one).edition)
      assert a.errors.on(:edition)
    end
  end
  
  private
  
  def create_record(options = {})
    record = Reading.new({ :title => 'XXX', :authors => 'Doe, J.', :edition => '1st' }.merge(options))
    record.save
    record
  end
end
