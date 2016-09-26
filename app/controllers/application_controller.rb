class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private 
    # 确保用户已经登陆
    def logged_in_user
      unless logged_in?
        store_locaiton
        flash[:danger]="Please log in."
        redirect_to login_path
      end
    end



end
