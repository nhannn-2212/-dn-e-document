class UserMailer < ApplicationMailer
  def block_user user
    @user = user
    mail to: user.email, subject: t("email.subject.block_user")
  end

  def upload_doc user, doc
    @user = user
    @doc = doc
    mail to: user.email, subject: t("email.subject.upload_doc")
  end

  def account_activation user
    @user = user
    mail to: user.email, subject: t("email.subject.account_activation")
  end
end
