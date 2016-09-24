class SessionsController < ApplicationController
  def new
  end

  def create
    @user=User.find_by(email:params[:session][:email].downcase)
    if @user&&@user.authenticate(params[:session][:password])
      # 登陆成功
      log_in(@user)
      params[:session][:remember_me]=='1'?remember(@user):forget(@user)
      redirect_back_or @user
    else 
      # 登陆失败
      flash.now[:danger]="Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    log_out  if logged_in?  
    redirect_to root_url    
  end
end
