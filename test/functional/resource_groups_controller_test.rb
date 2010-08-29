require 'test_helper'

class ResourceGroupsControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:course_resources)
    login_as(:quentin)
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:course_resources)
    login_as(:admin)
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:course_resources)
  end

  test "should obey role access" do
    assert_users_access( { :admin => true, :quentin => true  }, "index", :course_id => 1 )
  end
  
end
