class AdminMailer < ApplicationMailer
  def create_cate cate
    @cate = cate
    mail to: User.admin.pluck(:email), subject: t("email.subject.create_cate")
  end

  def monthly_report
    @new_member = User.find_in_month.size
    @download_times = History.find_in_month.size
    @upload_times = Document.find_in_month.size
    mail to: User.admin.pluck(:email), subject: t("email.subject.monthly_report")
  end
end
