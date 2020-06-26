class AdminController < ApplicationController
  skip_authorization_check
  before_action :require_admin
  include AdminHelper
  include CategoriesHelper

  def require_admin
    return if current_user&.admin?

    flash[:danger] = t "error.not_admin"
    redirect_to root_url
  end
end
