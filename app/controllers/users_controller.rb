class UsersController < ApplicationController
  before_action :load_user, only: %i(show favorites)

  def show
    if current_user != @user
      @documents = @user.documents.approve.sort_by_name.paginate(page: params[:page], per_page: Settings.per_page)
    else
      @documents = @user.documents.sort_by_name.paginate(page: params[:page], per_page: Settings.per_page)
    end
  end

  def favorites
    if current_user != @user
      flash[:danger] = t "error.not_permission"
      redirect_to root_url
    else
      @documents = @user.fav_docs.paginate(page: params[:page], per_page: Settings.per_page)
      render "show_favdocs"
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "error.invalid_ID"
    redirect_to root_url
  end

  def user_params
    params.require(:user)
          .permit :fullname, :email, :password, :password_confirmation
  end
end
