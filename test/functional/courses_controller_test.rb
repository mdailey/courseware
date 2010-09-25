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
    login_as(:waheed)
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

  test "should require course fields" do
    login_as(:admin)
    assert_no_difference('Course.count') do
      post :create, :course => { }
    end
    assert_response :success
    assert assigns(:course).errors.on(:year)
    assert assigns(:course).errors.on(:semester)
    assert assigns(:course).errors.on(:name)
    assert assigns(:course).errors.on(:code)
  end

  test "should fail to create course" do
    assert_no_difference('Course.count') do
      post :create, :course => { }
    end
    assert_response :unauthorized
  end

  test "instructor should fail to create course" do
    login_as(:waheed)
    assert_no_difference('Course.count') do
      post :create, :course => { }
    end
    assert_response :unauthorized
  end

  test "should clone course" do
    login_as(:admin)
    assert_difference('Course.count') do
      get :clone, :id => courses(:one).to_param
    end
    course_id = assigns(:new_course).id
    assert course_id
    course = Course.find(course_id)
    assert course.year == Time.now.year
    assert course.instructors.size > 0
    assert course.menu_actions.size > 0
    assert course.blurbs.size > 0
    assert course.readings.size > 0
    assert course.resource_groups.size > 0
    assert_redirected_to edit_course_path(assigns(:new_course))
  end

  test "should fail to clone course" do
    get :clone, :id => courses(:one).to_param
    assert_response :unauthorized
  end
  
  test "user should fail to clone course" do
    login_as(:quentin)
    get :clone, :id => courses(:one).to_param
    assert_response :unauthorized
  end
  
  test "instructor should fail to clone course" do
    login_as(:waheed)
    get :clone, :id => courses(:two).to_param
    assert_response :unauthorized
    get :clone, :id => courses(:one).to_param
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
  
  test "instructor should get edit" do
    login_as(:waheed)
    get :edit, :id => courses(:two).to_param
    assert_response :success
  end

  test "should fail to get edit" do
    get :edit, :id => courses(:one).to_param
    assert_response :unauthorized
  end
  
  test "user should fail to get edit" do
    login_as(:quentin)
    get :edit, :id => courses(:one).to_param
    assert_response :unauthorized
  end
  
  test "instructor should fail to get edit" do
    login_as(:waheed)
    get :edit, :id => courses(:one).to_param
    assert_response :unauthorized
  end

  test "should update course" do
    login_as(:admin)
    put :update, :id => courses(:one).to_param, :course => { }
    assert_redirected_to edit_course_path(assigns(:course))
  end

  test "instructor should update course" do
    login_as(:waheed)
    put :update, :id => courses(:two).to_param, :course => { }
    assert_redirected_to edit_course_path(assigns(:course))
  end

  test "should fail to update course" do
    put :update, :id => courses(:one).to_param, :course => { }
    assert_response :unauthorized
  end

  test "user should fail to update course" do
    login_as(:quentin)
    put :update, :id => courses(:one).to_param, :course => { }
    assert_response :unauthorized
  end

  test "instructor should fail to update course" do
    login_as(:waheed)
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
  
  test "instructor should fail to destroy course" do
    login_as(:waheed)
    assert_no_difference('Course.count') do
      delete :destroy, :id => courses(:two).to_param
    end
    assert_response :unauthorized
  end
  
  test "should obey role access" do
    assert_users_access( { :admin => true, :quentin => true,  :waheed => true  }, "index" )
    assert_users_access( { :admin => true, :quentin => true,  :waheed => true  }, "show", :id => courses(:one).to_param )
    assert_users_access( { :admin => true, :quentin => true,  :waheed => true  }, "static", :id => courses(:one).to_param, :static_action => "action" )
    assert_users_access( { :admin => true, :quentin => false, :waheed => false }, "destroy", :id => courses(:one).to_param )
    assert_users_access( { :admin => true, :quentin => false, :waheed => false }, "new" )
    assert_users_access( { :admin => true, :quentin => false, :waheed => true  }, "update", :id => courses(:two).to_param )
    assert_users_access( { :admin => true, :quentin => false, :waheed => true  }, "edit", :id => courses(:two).to_param )
    assert_users_access( { :admin => true, :quentin => false, :waheed => false }, "create" )
    assert_users_access( { :admin => true, :quentin => false, :waheed => false }, "clone", :id => courses(:one).to_param )
  end

end
