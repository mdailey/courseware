require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:courses)
    login_as(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:courses)
    login_as(:quentin)
    get :index
    assert_response :success
    assert_not_nil assigns(:courses)
  end

  test "should get new" do
    login_as(:admin)
    get :new
    assert_response :success
  end

  test "should fail to get new" do
    get :new
    assert_response :unauthorized
    login_as(:quentin)
    get :new
    assert_response :unauthorized
  end

  test "should create course" do
    login_as(:admin)
    assert_difference('Course.count') do
      post :create, :course => { :year => 2010, :semester => 'August', :name => 'MyCourse', :code => 'CS101' }
    end
    assert_redirected_to edit_course_path(assigns(:course))
  end

  test "should fail to create course" do
    assert_no_difference('Course.count') do
      post :create, :course => { }
    end
    assert_response :unauthorized
  end

  test "should show course" do
    get :show, :id => courses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    login_as(:admin)
    get :edit, :id => courses(:one).to_param
    assert_response :success
  end

  test "should fail to get edit" do
    get :edit, :id => courses(:one).to_param
    assert_response :unauthorized
    login_as(:quentin)
    get :edit, :id => courses(:one).to_param
    assert_response :unauthorized
  end

  test "should update course" do
    login_as(:admin)
    put :update, :id => courses(:one).to_param, :course => { }
    assert_redirected_to edit_course_path(assigns(:course))
  end

  test "should fail to update course" do
    put :update, :id => courses(:one).to_param, :course => { }
    assert_response :unauthorized
  end

  test "should destroy course" do
    login_as(:admin)
    assert_difference('Course.count', -1) do
      delete :destroy, :id => courses(:one).to_param
    end
    assert_redirected_to courses_path
  end
  
  test "should fail to destroy course" do
    assert_no_difference('Course.count') do
      delete :destroy, :id => courses(:one).to_param
    end
    assert_response :unauthorized
  end
  
  test "should obey role access" do
    assert_users_access( { :admin => true, :quentin => true  }, "index" )
    assert_users_access( { :admin => true, :quentin => true  }, "show" )
    assert_users_access( { :admin => true, :quentin => true  }, "static" )
    assert_users_access( { :admin => true, :quentin => false }, "destroy" )
    assert_users_access( { :admin => true, :quentin => false }, "new" )
    assert_users_access( { :admin => true, :quentin => false }, "update" )
    assert_users_access( { :admin => true, :quentin => false }, "edit" )
    assert_users_access( { :admin => true, :quentin => false }, "create" )
  end

end
