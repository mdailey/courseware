require 'test_helper'

class ExamsControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:exams)
    login_as(:quentin)
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:exams)
    login_as(:admin)
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:exams)
  end

  test "should obey role access" do
    assert_users_access( { :admin => true, :quentin => true  }, "index" )
  end

end
