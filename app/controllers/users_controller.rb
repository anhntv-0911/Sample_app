class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.activated.page(params[:page]).per Settings.user_per_page
  end

  def show
    @microposts = @user.microposts.desc.page(params[:page]).per Settings.user_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "flash.notify_check"
      redirect_to @user
    else
      render :new
    end
  end

  def edit;  end

  def update
    if @user.update user_params
      flash[:success] = t "users.update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "flash.del_success"
      redirect_to users_path
    else
      flash[:danger] = t "flash.del_fail"
      redirect_to users_path
    end
  end

  private
    def user_params
      params.require(:user).permit :name, :email, :password, :password_confirmation
    end

    def correct_user
      redirect_to(root_path) unless current_user? @user
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def load_user
      @user = User.find_by id: params[:id]
      return if @user
      flash[:notify] = t "users.no_account"
      redirect_to root_path
    end
end
