# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def password_reset_email
    user = User.last
    UserMailer.password_reset_email(user, SecureRandom.hex)
  end

  def invite_email
    user = User.last
    UserMailer.invite_email(user, SecureRandom.hex)
  end
end
