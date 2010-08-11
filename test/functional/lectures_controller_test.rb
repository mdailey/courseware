require 'test_helper'

class LecturesControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:lectures)
    login_as(:quentin)
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:lectures)
    login_as(:admin)
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:lectures)
  end

  test "should obey role access" do
    assert_users_access( { :admin => true, :quentin => true  }, "index" )
  end
end
