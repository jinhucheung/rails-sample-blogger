require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup 
    @user=users(:test_user)
    @others=users(:test_user2)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect indxe when not logged in" do 
    get users_path
    assert_redirected_to login_path
  end

  test "should not allow the admin attribute to be edited via the web" do 
    log_in_as(@others)
    assert_not @others.admin?
    patch user_path(@others),params:{user:{
                                           password: "",
                                           password_confirmation:"",
                                           admin:true } }
    assert_not @others.admin?
  end

  test "should redirect destroy when not logged in" do 
    assert_no_difference 'User.count' do 
      delete user_path(@others)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when logged in as a non-admin" do 
    log_in_as(@others)
    assert_no_difference 'User.count' do 
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
end
