require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  fixtures :courses, :assignments
  
  def test_should_create_assignment
    assert_difference 'Assignment.count' do
      a = create_assignment
      assert !a.new_record?, "#{a.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_course
    assert_no_difference 'Assignment.count' do
      a = create_assignment(:course_id => 5)
      assert a.errors.on(:course)
    end
  end
  
  def test_should_require_unique_numbers
    assert_no_difference 'Assignment.count' do
      a = create_assignment(:course_id => 1, :number => 1)
      assert a.errors.on(:number)
    end
  end
  
  def test_should_find_assignments
    assert Course.find(1).assignments.size == 2
  end

  private
  
  def create_assignment(options = {})
    record = Assignment.new({ :course_id => 2, :number => 1,
                              :title => 'Assignment', :ps_flabel => 'PDF',
                              :ps_fname => 'a1.pdf', :soln_flabel => 'PDF',
                              :soln_fname => 'a2.pdf' }.merge(options))
    record.save
    record
  end
end
