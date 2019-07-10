class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "flash.sentPasswordReset"
      redirect_to root_path
    else
      flash[:danger] = t "flash.emailInvalid"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("passwordReset.notEmpty")
      render :edit
    elsif update user_params
      log_in @user
      @user.update reset_digest: nil
      flash[:success] = t "passwordReset.success"
      redirect_to @user
    else
      render :edit
    end
  end

  private
    def user_params
      params.require (:user).permit :password, :password_confirmation
    end

    def get_user
      @user = User.find_by email: params[:email]
      return if @user
      flash[:info] = t "users.noAccount"
      redirect_back_or root_path
    end

    def valid_user
      return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      flash[:danger] = t "passwordReset.emailValid"
      redirect_back_or root_path
    end

    def check_expriation
      return unless @user.password_reset_expired?
      flash[:danger] = t "flash.passExp"
      redirect_to new_password_reset_url
    end
end
