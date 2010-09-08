require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase

  def test_should_not_show
    login_as(:waheed)
    get :show, :id => users(:quentin).id.to_s
    assert_response :unauthorized
  end

  def test_should_show
    login_as(:quentin)
    get :show, :id => users(:quentin).id.to_s
    assert_response :success
    login_as(:admin)
    get :show, :id => users(:quentin).id.to_s
    assert_response :success
  end

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      assert_response :redirect
    end
  end
  
  def test_should_require_old_password_on_login_change
    put :update, :id => users(:quentin).id.to_s, :user => { :login => 'quire69'}
    assert_response :unauthorized
    login_as(:quentin)
    put :update, :id => users(:quentin).id.to_s, :user => { :login => 'quire69'}
    assert assigns(:user).errors.on(:old_password)
    assert_response :success
  end

  def test_should_fail_to_update
    login_as(:waheed)
    put :update, :id => users(:quentin).id.to_s, :user => { :login => 'quire69' }
    assert_response :unauthorized
  end

  def test_should_require_old_password_on_email_change
    login_as(:quentin)
    put :update, :id => users(:quentin).id.to_s, :user => { :email => 'quire69@abc.com' }
    assert assigns(:user).errors.on(:old_password)
    assert_response :success
  end

  def test_should_update_email
    login_as(:quentin)
    put :update, :id => users(:quentin).id.to_s, :user => { :email => 'quire69@abc.com', :old_password => 'monkey' }
    assert assigns(:user).errors.empty?
    assert_redirected_to user_path(users(:quentin))
  end

  def test_should_update_name
    login_as(:quentin)
    put :update, :id => users(:quentin).id.to_s, :user => { :name => 'Tarantino', :old_password => 'monkey' }
    assert assigns(:user).errors.empty?
    assert_redirected_to user_path(users(:quentin))
  end

  def test_should_require_old_password_on_password_change
    login_as(:quentin)
    put :update, :id => users(:quentin).id.to_s, :user => { :password => 'new password', :password_confirmation => 'new password' }
    assert assigns(:user).errors.on(:old_password)
    assert_response :success
  end

  def test_should_fail_to_update_password
    login_as(:quentin)
    put :update, :id => users(:quentin).id.to_s, :user => { :password => 'new password', :password_confirmation => 'new password', :old_password => 'money' }
    assert assigns(:user).errors.on(:old_password)
    assert_response :success
  end

  def test_should_update_password
    login_as(:quentin)
    put :update, :id => users(:quentin).id.to_s, :user => { :password => 'new password', :password_confirmation => 'new password', :old_password => 'monkey' }
    assert assigns(:user).errors.empty?
    assert_redirected_to user_path(users(:quentin))
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end
  
  def test_should_sign_up_user_in_pending_state
    create_user
    assigns(:user).reload
    assert assigns(:user).pending?
  end
  
  def test_should_sign_up_user_with_activation_code
    create_user
    assigns(:user).reload
    assert_not_nil assigns(:user).activation_code
  end

  def test_should_activate_user
    assert_nil User.authenticate('aaron', 'test')
    get :activate, :activation_code => users(:aaron).activation_code
    assert_redirected_to '/login'
    assert_not_nil flash[:notice]
    assert_equal users(:aaron), User.authenticate('aaron', 'monkey')
  end
  
  def test_should_not_activate_user_without_key
    get :activate
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :activate, :activation_code => ''
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end
  
  def test_should_obey_role_access
    assert_users_access( { :admin => true, :quentin => true,  :waheed => true  }, "show", :id => users(:quentin).id.to_s )
    assert_users_access( { :admin => true, :quentin => true,  :waheed => true  }, "new" )
    assert_users_access( { :admin => true, :quentin => true,  :waheed => true  }, "update", :id => users(:quentin).id.to_s )
    assert_users_access( { :admin => true, :quentin => true,  :waheed => true  }, "create" )
    assert_users_access( { :admin => true, :quentin => true,  :waheed => true  }, "activate", :id => users(:quentin).id.to_s )
    assert_users_access( { :admin => true, :quentin => false, :waheed => false }, "suspend", :id => users(:quentin).id.to_s )
    assert_users_access( { :admin => true, :quentin => false, :waheed => false }, "unsuspend", :id => users(:quentin).id.to_s )
    assert_users_access( { :admin => true, :quentin => false, :waheed => false }, "destroy", :id => users(:quentin).id.to_s )
    assert_users_access( { :admin => true, :quentin => false, :waheed => false }, "purge", :id => users(:quentin).id.to_s )
  end

  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
