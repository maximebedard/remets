class UserMailer < ApplicationMailer
  def password_reset_email(user, _secret)
    @user = user

    mail(
      to: @user.email,
      subject: "Remets - Password reset",
    )
  end

  def invite_email(user, _secret)
    @user = user

    mail(
      to: @user.email,
      subject: "Remets - Invitation",
    )
  end
end
