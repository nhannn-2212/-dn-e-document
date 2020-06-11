module ApplicationHelper
  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = Settings.flash_success_type if type == Settings.flash_notice_type
      type = Settings.flash_error_type if type == Settings.flash_alert_type
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end
    flash_messages.join("\n").html_safe
  end
end
