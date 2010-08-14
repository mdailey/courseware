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
    assert_users_access( { :admin => true, :quentin => false  }, "edit" )
    assert_users_access( { :admin => true, :quentin => false  }, "update" )
  end
  
  test "should get edit" do
    login_as(:admin)
    get :edit, :course_id => courses(:one).to_param
    assert_response :success
  end

  test "should get edit json" do
    login_as(:admin)
    get :edit, :course_id => courses(:one).to_param, :format => 'json'
    assert_response :success
  end

  test "should fail to get edit" do
    get :edit, :course_id => courses(:one).to_param
    assert_response :unauthorized
    login_as(:quentin)
    get :edit, :course_id => courses(:one).to_param
    assert_response :unauthorized
  end
  
  test "should create lecture" do
    login_as(:admin)
    assert_difference('Lecture.count') do
      post_record
    end
    assert_response :success
  end

  test "should fail to create lecture" do
    assert_no_difference('Lecture.count') do
      post_record
    end
    assert_response :unauthorized
  end

  test "should update lecture" do
    login_as(:admin)
    post_record({ :number => 1, :id => 1, :topics => 'abcd', :readings => '1234', :lecture_dates_string => '2010-08-09', :oper => 'edit' })
    assert_response :success
  end

  test "should fail to update lecture" do
    post_record({ :number => 1, :id => 1, :topics => 'abcd', :readings => '1234', :lecture_dates_string => '2010-08-09', :oper => 'edit' })
    assert_response :unauthorized
  end

  private
  
  def post_record(options = {})
    params = { :number => 10, :lecture_dates_string => '2010-08-08', :topics => 'abc', :readings => '123', :oper => 'add', :id => '_empty', :course_id => 1 }.merge(options)
    post :update, params
  end
end
