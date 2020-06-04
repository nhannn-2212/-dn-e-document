class UsersController < ApplicationController
  before_action :load_user, only: :show

  def new; end

  def create; end

  def show
    if current_user != @user
      @documents = @user.documents.approve.sort_by_name.paginate(page: params[:page], per_page: Settings.per_page)
    else
      @documents = @user.documents.sort_by_name.paginate(page: params[:page], per_page: Settings.per_page)
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "error.invalid_ID"
    redirect_to root_url
  end
end
