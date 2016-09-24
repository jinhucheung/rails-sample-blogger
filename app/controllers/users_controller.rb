class UsersController < ApplicationController
  before_action :logged_in_user,only:[:destroy,:index,:edit,:update]
  before_action :correct_user,only:[:edit,:update]
  before_action :admin_user,only:[:destroy]
  
  def new
    @user=User.new
  end

  def show
    @user=User.find(params[:id]) 
    redirect_to root_url and return unless @user.activated?
  end

  def create
    @user=User.new(user_params)
#      debugger
    if @user.save
#     log_in @user
#     remember @user
      @user.send_activation_email
      flash[:info]="Please check your email to activate your account."
      redirect_to root_url
    else 
      render "new"
    end
  end

  def edit
    @user=User.find(params[:id])
  end


  def update 
    @user=User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success]="Profile updated"
      redirect_to @user
    else 
      render 'edit'
    end
  end

  def index
    @users=User.where(activated:true).paginate(page:params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success]="User deleted"
    redirect_to users_path
  end

  private 
    # 获取表单传回的用户参数
    def user_params
      # 指定请求的用户参数须包含:name,:email,:password,:password_confirmation
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end

    # 确保用户已经登陆
    def logged_in_user
      unless logged_in?
        store_locaiton
        flash[:danger]="Please log in."
        redirect_to login_path
      end
    end

    def correct_user
      _user=User.find(params[:id])
      redirect_to root_url unless current_user? _user 
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
