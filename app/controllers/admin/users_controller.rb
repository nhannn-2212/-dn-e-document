class Admin::UsersController < AdminController
  before_action :load_user, :check_role_admin, :check_ban, only: :update
  before_action :load_all_users, only: :index

  def index; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "success.update_user"
    else
      flash[:danger] = t "error.update_user"
    end
    redirect_to request.referer
  end

  private

  def user_params
    params.require(:user)
          .permit :role, :active
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "error.invalid_ID"
    redirect_to redirect_to request.referer
  end

  def load_all_users
    @users = User.sort_by_name.paginate page: params[:page], per_page: Settings.per_page
  end

  def check_role_admin
    return unless @user.admin? && (params[:user][:role] == Settings.role_member || params[:user][:active] == Settings.false_string)

    flash[:danger] = t "error.edit_admin"
    redirect_to request.referer
  end

  def check_ban
    @user.send_block_email if params[:user][:active] == Settings.false_string
  end
end
