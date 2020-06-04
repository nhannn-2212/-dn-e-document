class AdminController < ApplicationController
  before_action :require_admin
  include AdminHelper

  def require_admin
    return if current_user.admin?

    flash[:danger] = t "error.not_admin"
    redirect_to root_url
  end
end
