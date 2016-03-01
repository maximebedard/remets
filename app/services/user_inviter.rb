class UserInviter
  def initialize(email)
    @email = email
  end

  def call
    user = User.find_by(email: email)
    return user if user.present?

    secret, digest = User.digest(SecureRandom.hex)
    invite_user(secret, digest)
  end

  private

  attr_reader :email

  def invite_user(secret, digest)
    User.new(
      email: email,
      password: SecureRandom.hex,
      reset_password_digest: digest,
      reset_password_sent_at: Time.zone.now,
      invited_secret: secret,
    )
  end
end
