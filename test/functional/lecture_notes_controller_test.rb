require 'test_helper'

class LectureNotesControllerTest < ActionController::TestCase
  
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

  test "should show lecture note" do
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

  test "should obey role access" do
    assert_users_access( { :admin => true, :quentin => true  }, "index", :course_id => 1 )
    assert_users_access( { :admin => true, :quentin => true  }, "show", :course_id => 1 )
    assert_users_access( { :admin => true, :quentin => false }, "edit", :course_id => 1 )
    assert_users_access( { :admin => true, :quentin => false }, "update", :course_id => 1 )
  end
  
  test "should add lecture note" do
    login_as(:admin)
    assert_difference('LectureNote.count') do
      put_record( {}, true )
    end
    assert_redirected_to edit_lecture_notes_path({:course_id => 1})
  end

  test "should update lectures" do
    login_as(:admin)
    assert_difference('LectureNote.count',0) do
      put_record( {}, false )
    end
    assert_redirected_to edit_lecture_notes_path({:course_id => 1})
  end
  
  test "should delete lecture" do
    login_as(:admin)
    assert_difference('LectureNote.count',-1) do
      put_record( {}, false, false )
    end
    assert_redirected_to edit_lecture_notes_path({:course_id => 1})
  end
  
  test "should fail to update lecture" do
    put_record
    assert_response :unauthorized
  end
  
  private
  
  def put_record(options = {}, new=true, existing=true)
    file = fixture_file_upload('files/blank.pdf','application/pdf')
    params = { :course => {
      :new_lecture_note_attributes => new ?
        [{ :number => '6', :topic => 'Syllabus', :file_name => 'syllabus.pdf', :file_label => 'PDF',
           :lecture_note_file => file }] :
        [{ :number => '', :topic => '', :file_name => '', :file_label => ''}],
      :existing_lecture_note_attributes => existing ?
        {"1" => { :number => '1', :topic => 'MyString', :file_name => 'lecture_note1.pdf', :file_label => 'PDF'},
         "2" => { :number => '2', :topic => 'MyString', :file_name => 'lecture_note2.pdf', :file_label => 'PDF'}} :
        {"1" => { :number => '1', :topic => 'MyString', :file_name => 'lecture_note1.pdf', :file_label => 'PDF'}},
      :lecture_notes_blurb => { :contents => "" }},
      :course_id => 1 }.merge(options)
    put :update, params
  end
  
end
