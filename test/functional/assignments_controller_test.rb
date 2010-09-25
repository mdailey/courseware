require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase
  
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

  test "should show assignment" do
    get :show, :id => 1, :course_id => 1
    assert_response :success
    login_as(:quentin)
    get :show, :id => 1, :course_id => 1
    assert_response :success
    login_as(:admin)
    get :show, :id => 1, :course_id => 1
    assert_response :success
  end
  
  test "should fail to show assignment without data" do
    login_as(:admin)
    assert_difference('Assignment.count') do
      put_record( {}, true )
    end
    assert_redirected_to edit_assignments_path({:course_id => 1})
    assignment = courses(:one).assignments.find_by_number(6)
    if assignment.document_file
      assignment.document_file.delete
    end
    if assignment.assignment_file
      assignment.assignment_file.delete
    end
    assert_raise(RuntimeError) do
      get :show, :id => assignment.to_param, :course_id => 1
    end
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
    assert_users_access( { :admin => true, :quentin => true,  :waheed => true  }, "index", :course_id => courses(:one).to_param )
    assert_users_access( { :admin => true, :quentin => true,  :waheed => true  }, "show", :course_id => courses(:one).to_param, :id => 1 )
    assert_users_access( { :admin => true, :quentin => false, :waheed => false }, "edit", :course_id => courses(:one).to_param )
    assert_users_access( { :admin => true, :quentin => false, :waheed => false }, "update", :course_id => courses(:one).to_param )
    assert_users_access( { :admin => true, :quentin => false, :waheed => true  }, "edit", :course_id => courses(:two).to_param )
    assert_users_access( { :admin => true, :quentin => false, :waheed => true  }, "update", :course_id => courses(:two).to_param )
  end
  
  test "should add assignment" do
    login_as(:admin)
    assert_difference('Assignment.count') do
      put_record( {}, true )
    end
    assert_redirected_to edit_assignments_path({:course_id => 1})
  end

  test "should update assignments" do
    login_as(:admin)
    assert_difference('Assignment.count',0) do
      put_record( { :course => {
         :new_assignment_attributes => [{:number=>"", :title=>"", :ps_fname=>"", :ps_flabel=>""}],
         :existing_assignment_attributes => {
           "1" => { :number => '1', :title => 'MyString', :ps_fname => 'assignment1.pdf', :ps_flabel => 'PDF'},
           "2" => { :number => '3', :title => 'MyString2', :ps_fname => 'assignment3.pdf', :ps_flabel => 'PPT'}}}}, false )
    end
    assignment = Assignment.find(2).reload
    assert_equal 3, assignment.number
    assert_equal 'MyString2', assignment.title
    assert_equal 'assignment3.pdf', assignment.ps_fname
    assert_equal 'PPT', assignment.ps_flabel
    assert_redirected_to edit_assignments_path({:course_id => 1})
  end
  
  test "should fail to update assignments" do
    login_as(:admin)
    put_record( { :course => {
       :new_assignment_attributes => [{:number=>"", :title=>"", :ps_fname=>"", :ps_flabel=>""}],
       :existing_assignment_attributes => {
           "1" => { :number => '1', :title => 'MyString', :ps_fname => 'assignment1.pdf', :ps_flabel => 'PDF'},
           "2" => { :number => '1', :title => 'MyString', :ps_fname => 'assignment2.pdf', :ps_flabel => 'PDF'}}}}, false )
    assert_response :success
    assert assigns(:course).errors.on("assignments.number")
  end
  
  test "should update blurb" do
    login_as(:admin)
    put_record( {}, false, true, 'New blurb' )
    assert_equal Course.find(courses(:one).id).assignments_blurb.contents, 'New blurb'
  end
  
  test "should delete assignment" do
    login_as(:admin)
    assert_difference('Assignment.count',-1) do
      put_record( {}, false, false )
    end
    assert_redirected_to edit_assignments_path({:course_id => 1})
  end
  
  test "should fail to update assignment" do
    put_record
    assert_response :unauthorized
  end
  
  private
  
  def put_record(options = {}, new=true, existing=true, blurb='')
    file = fixture_file_upload('files/blank.pdf','application/pdf')
    params = { :course => {
      :new_assignment_attributes => new ?
        [{ :number => '6', :title => 'Syllabus', :ps_fname => 'syllabus.pdf', :ps_flabel => 'PDF',
           :document_file => file }] :
        [{ :number => '', :title => '', :ps_fname => '', :ps_flabel => ''}],
      :existing_assignment_attributes => existing ?
        {"1" => { :number => '1', :title => 'MyString', :ps_fname => 'assignment1.pdf', :ps_flabel => 'PDF'},
         "2" => { :number => '2', :title => 'MyString', :ps_fname => 'assignment2.pdf', :ps_flabel => 'PDF'}} :
        {"1" => { :number => '1', :title => 'MyString', :ps_fname => 'assignment1.pdf', :ps_flabel => 'PDF'}},
      :assignments_blurb => { :contents => "#{blurb}" }},
      :course_id => 1 }.merge(options)
    put :update, params
  end
  
end
