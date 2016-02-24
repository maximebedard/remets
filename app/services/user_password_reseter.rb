class UserPasswordReseter
  def initialize(user)
    @user = user
  end

  def call
    secret, digest = User.digest(SecureRandom.hex)

    update_reset_password(digest)
    send_reset_password_notification(secret)
  end

  private

  attr_reader :user

  def update_reset_password(digest)
    user.update(
      reset_password_digest: digest,
      reset_password_sent_at: Time.zone.now,
    )
  end

  def send_reset_password_notification(secret)
    UserMailer.password_reset_email(user, secret).deliver_later
  end
end
