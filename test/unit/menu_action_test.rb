require 'test_helper'

class MenuActionTest < ActiveSupport::TestCase
  fixtures :courses, :menu_actions
 
  def test_should_create_menu_action
    assert_difference 'MenuAction.count' do
      a = create_record
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_course
    assert_no_difference 'MenuAction.count' do
      a = create_record(:course_id => 5)
      assert a.errors.on(:course)
    end
  end
  
  def test_should_require_unique
    assert_no_difference 'MenuAction.count' do
      a = create_record(:course_id => 1, :action => 'home')
      assert a.errors.on(:action)
      a = create_record(:course_id => 1, :order => 1)
      assert a.errors.on(:order)
      a = create_record(:course_id => 1, :tag => 'Home')
      assert a.errors.on(:tag)
    end
  end
  
  def test_should_find_menu_actions
    assert Course.find(1).menu_actions.size == 7
  end

  private
  
  def create_record(options = {})
    record = MenuAction.new({ :course_id => 2,
                              :order => 1, :tag => 'Home',
                              :action => 'home' }.merge(options))
    record.save
    record
  end
end
