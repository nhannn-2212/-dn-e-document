class SessionsController < ApplicationController
  before_action :find_user_by_email, :check_activated, only: :create

  def new
    if logged_in?
      flash[:warning] = t "warning.logged_in"
      redirect_to root_url
    else
      render :new
    end
  end

  def create
    if @user.authenticate params[:session][:password]
      log_in @user
      redirect_to root_url
    else
      flash.now[:danger] = t "error.invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def find_user_by_email
    @user = User.find_by email: params[:session][:email].downcase
    return if @user

    flash.now[:danger] = t "error.invalid_email"
    render :new
  end

  def check_activated
    return if @user.active

    flash[:warning] = t "warning.account_activated"
    redirect_to root_url
  end
end
