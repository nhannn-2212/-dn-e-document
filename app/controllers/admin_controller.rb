class AdminController < ApplicationController
  def require_admin
    return if current_user.admin?

    flash[:danger] = t "error.not_admin"
    redirect_to root_url
  end
end
