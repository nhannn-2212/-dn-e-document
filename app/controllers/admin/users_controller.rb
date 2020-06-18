class Admin::UsersController < AdminController
  load_and_authorize_resource param_method: :user_params
  before_action :check_role_admin, :check_ban, only: :update

  def index
    @search = User.search(params[:q])
    @users = @search.result.sort_by_name.paginate page: params[:page], per_page: Settings.per_page
  end

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

  def check_role_admin
    return unless @user.admin? && (params[:user][:role] == Settings.role_member || params[:user][:active] == Settings.false_string)

    flash[:danger] = t "error.edit_admin"
    redirect_to request.referer
  end

  def check_ban
    @user.send_block_email if params[:user][:active] == Settings.false_string
  end
end
