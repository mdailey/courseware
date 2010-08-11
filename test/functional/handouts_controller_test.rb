require 'test_helper'

class HandoutsControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:handouts)
    login_as(:quentin)
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:handouts)
    login_as(:admin)
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:handouts)
  end

  test "should show handout" do
    get :show, :id => 1, :course_id => 1
    assert_response :success
    login_as(:quentin)
    get :show, :id => 1, :course_id => 1
    assert_response :success
    login_as(:admin)
    get :show, :id => 1, :course_id => 1
    assert_response :success
  end

  test "should obey role access" do
    assert_users_access( { :admin => true, :quentin => true  }, "index" )
    assert_users_access( { :admin => true, :quentin => true  }, "show" )
  end
  
end
