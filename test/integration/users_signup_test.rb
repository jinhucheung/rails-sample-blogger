require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "invalid signup information" do 
    get signup_path
    assert_no_difference 'User.count' do 
      post users_path, params:{ user:{ name:"",
                                       email:"user@invalid",
                                       password:"foo",
                                       password_confirmation:"bar" }}
    end
    assert_template 'users/new'
    assert_select "div[class=?]","error_explanation"
  end

  test "valid signup information" do 
    get signup_path
    assert_difference 'User.count' do 
      post users_path, params:{ user: { name:"example",
                                        email:"example@exam.com",
                                        password:"exampletest",
                                        password_confirmation:"exampletest" }} 
    end
    follow_redirect!
#    assert_template 'users/show'
    assert_not flash.empty?
#    assert is_logged_in?
#    assert is_remembered?
  end

  test "invalid singup with password not equal password_confirmation" do 
    get signup_path
    assert_template 'users/new'
    post users_path, params:{user:{name:"example",email:"example@exam.com",password:"test1234",password_confirmation:"test123"}}
    assert_template 'users/new'
    assert_select "div.alert"
  end 

  test "valid signup information with account activation" do 
    get signup_path
    assert_difference 'User.count',1 do 
      post users_path,params:{user:{name:"ExampleUser",email:"user@testexample.com",
                                    password:"password",password_confirmation:"password"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size # 统计发送邮件,发送一个mail 
    user = assigns(:user)
    assert_not user.activated?
    # 尝试在激活前登录
    log_in_as(user)
    assert_not is_logged_in?
    # 激活令牌无效 
    get edit_account_activation_path("invalid token",email:user.email)
    assert_not is_logged_in?
    # 令牌有效,电子邮件地址不对
    get edit_account_activation_path(user.activation_token,email:"wrong")
    assert_not is_logged_in?
    # 激活令牌有效 
    get edit_account_activation_path(user.activation_token,email:user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end

