require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user=users(:test_user)
    @others=users(:test_user2)
  end

  test "unsuccessful edit" do 
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user),params:{user:{name:"",email:"foo@invalid",password:"foo",password_confirmation:"ho"}}
    assert_template 'users/edit'
    assert_select "div.alert",text:"The form contains 4 errors"
  end

  test "successful edit with friendly forwarding" do 
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name="newexampletest"
    email="newexmapletest@test.com"
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user),params:{user:{name:name,email:email,password:"",password_confirmation:""}}
    assert_not flash.empty?
    assert_redirected_to @user 
    @user.reload
    assert_equal name,@user.name 
    assert_equal email,@user.email
  end

  test "should redirect edit when not logged in" do 
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update when no logged in" do 
    patch user_path(@user),params:{user:{name:@user.name,email:@user.email}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit when logged in as wrong user" do 
    log_in_as(@others)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end 

  test "should redirect update when logged in as wrong user" do 
    log_in_as(@others)
    patch user_path(@user),params:{user:{name:@user.name,email:@user.email}}
    assert flash.empty?
    assert_redirected_to root_url
  end

end
