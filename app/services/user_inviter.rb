class UserInviter
  def initialize(email)
    @email = email
  end

  def call
    user = User.find_by(email: email)
    return user if user.present?

    secret, digest = User.digest(SecureRandom.hex)
    user = create_user_aot(digest)
    send_invite_notification(user, secret)

    user
  end

  private

  attr_reader :email

  def create_user_aot(digest)
    user = User.new(
      email: email,
      password: SecureRandom.hex,
      reset_password_digest: digest,
      reset_password_sent_at: Time.zone.now,
    )
    user.save(validate: false)
    user
  end

  def send_invite_notification(user, secret)
    UserMailer.invite_email(user, secret).deliver_later
  end
end
