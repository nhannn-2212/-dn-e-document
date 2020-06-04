class UsersController < ApplicationController
  before_action :load_user, only: :show

  def new; end

  def create; end

  def show
    @documents = @user.documents.by_title.paginate(page: params[:page], per_page: Settings.per_page)
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "error.invalid_ID"
    redirect_to root_url
  end
end
