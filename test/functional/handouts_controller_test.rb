require 'test_helper'

class HandoutsControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:file_list)
    login_as(:quentin)
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:file_list)
    login_as(:admin)
    get :index, :course_id => 1
    assert_response :success
    assert_not_nil assigns(:file_list)
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

  test "should get edit" do
    login_as(:admin)
    get :edit, :course_id => courses(:one).to_param
    assert_response :success
  end

  test "should fail to get edit" do
    get :edit, :course_id => courses(:one).to_param
    assert_response :unauthorized
    login_as(:quentin)
    get :edit, :course_id => courses(:one).to_param
    assert_response :unauthorized
  end

  test "instructor should fail to get edit" do
    login_as(:waheed)
    get :edit, :course_id => courses(:one).to_param
    assert_response :unauthorized
  end

  test "instructor should get edit" do
    login_as(:waheed)
    get :edit, :course_id => courses(:two).to_param
    assert_response :success
  end

  test "should obey role access" do
    assert_users_access( { :admin => true, :quentin => true,  :waheed => true  }, "index", :course_id => 1 )
    assert_users_access( { :admin => true, :quentin => true,  :waheed => true  }, "show", :course_id => 1, :id => 1 )
    assert_users_access( { :admin => true, :quentin => false, :waheed => true  }, "edit", :course_id => 1 )
    assert_users_access( { :admin => true, :quentin => false, :waheed => true  }, "update", :course_id => 1 )
  end
  
  test "should add handout" do
    login_as(:admin)
    assert_difference('Handout.count') do
      put_record( {}, true )
    end
    assert_redirected_to edit_handouts_path({:course_id => 1})
  end

  test "should update handouts" do
    login_as(:admin)
    assert_difference('Handout.count',0) do
      put_record( {}, false )
    end
    assert_redirected_to edit_handouts_path({:course_id => 1})
  end
  
  test "should update blurb" do
    login_as(:admin)
    put_record( {}, false, true, 'New blurb' )
    assert_equal Course.find(courses(:one).id).handouts_blurb.contents, 'New blurb'
  end
  
  test "should delete handout" do
    login_as(:admin)
    assert_difference('Handout.count',-1) do
      put_record( {}, false, false )
    end
    assert_redirected_to edit_handouts_path({:course_id => 1})
  end
  
  test "should fail to update handout" do
    put_record
    assert_response :unauthorized
  end
  
  private
  
  def put_record(options = {}, new=true, existing=true, blurb='')
    file = fixture_file_upload('files/blank.pdf','application/pdf')
    params = { :course => {
      :new_handout_attributes => new ?
        [{ :number => '6', :topic => 'Syllabus', :file_name => 'syllabus.pdf', :file_label => 'PDF',
           :handout_file => file }] :
        [{ :number => '', :topic => '', :file_name => '', :file_label => ''}],
      :existing_handout_attributes => existing ?
        {"1" => { :number => '1', :topic => 'MyString', :file_name => 'handout1.pdf', :file_label => 'PDF'},
         "2" => { :number => '2', :topic => 'MyString', :file_name => 'handout2.pdf', :file_label => 'PDF'}} :
        {"1" => { :number => '1', :topic => 'MyString', :file_name => 'handout1.pdf', :file_label => 'PDF'}},
      :handouts_blurb => { :contents => "#{blurb}" }},
      :course_id => 1 }.merge(options)
    put :update, params
  end

end
