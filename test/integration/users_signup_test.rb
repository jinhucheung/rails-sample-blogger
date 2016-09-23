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
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
    assert is_remembered?
  end
end
