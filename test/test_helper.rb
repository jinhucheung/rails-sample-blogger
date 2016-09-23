ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # 如果用户已登陆,返回true
  def is_logged_in?
    !session[:user_id].nil?
  end

  # 持久cookies记住用户
  def is_remembered?
    !cookies['remember_token'].nil?&&!cookies['user_id'].nil?
  end

  # 登陆指定用户
  def log_in_as(user)
    session[:user_id]=user.id
  end

end


class ActionDispatch::IntegrationTest 
    
  def log_in_as(user,password:'password',remember_me:'1')
    post login_path,params:{ session:{ email: user.email,
                                       password: password,
                                       remember_me: remember_me } }
  end

end
