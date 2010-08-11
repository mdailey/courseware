require 'test_helper'

class ReadingsControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:course_readings)
    login_as(:admin)
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:course_readings)
    login_as(:quentin)
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:course_readings)
  end

  test "should get edit" do
    login_as(:admin)
    get :edit, :course_id => 1
    assert_response :success
  end

  test "should fail to get edit" do
    get :edit, :course_id => 1
    assert_response :unauthorized
    login_as(:quentin)
    get :edit, :course_id => 1
    assert_response :unauthorized
  end

  test "should update reading" do
    login_as(:admin)
    put :update, :id => 1, :course_id => 1, :course_reading => { }
    assert_redirected_to edit_course_readings_path(assigns(:course))
  end

  test "should fail to update reading" do
    put :update, :id => 1, :course_id => 1, :course_reading => { }
    assert_response :unauthorized
  end

  test "should obey role access" do
    assert_users_access( { :admin => true, :quentin => true  }, "index" )
    assert_users_access( { :admin => true, :quentin => false }, "update" )
    assert_users_access( { :admin => true, :quentin => false }, "edit" )
  end

end
