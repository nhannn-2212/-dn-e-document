class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :switch_locale
  include CategoriesHelper

  def switch_locale &action
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    {locale: I18n.locale}
  end

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
    I18n.default_locale = I18n.locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def configure_permitted_parameters
    added_attrs = [:fullname, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
