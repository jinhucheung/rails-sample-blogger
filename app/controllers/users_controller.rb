class UsersController < ApplicationController
  def new
    @user=User.new
  end

  def show
    @user=User.find(params[:id])
  end

  def create
    @user=User.new(user_params)
    #  debugger
    if @user.save
      log_in @user
      flash[:success]="Welcome to the Sample App!"
      redirect_to @user
    else 
      render "new"
    end
  end

  private 
    # 获取表单传回的用户参数
    def user_params
      # 指定请求的用户参数须包含:name,:email,:password,:password_confirmation
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
end
