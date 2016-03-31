class User < ActiveRecord::Base
  ADMIN_ROLE = "admin".freeze
  USER_ROLE = "user".freeze
  ROLES = [USER_ROLE, ADMIN_ROLE].freeze

  RESET_PASSWORD_WITHIN = 3.days.freeze

  has_many :memberships
  has_many :organizations, through: :memberships

  has_many :subscriptions
  has_many :subscribed_evaluations, through: :subscriptions, source: :evaluation

  has_many :submissions
  has_many :evaluations
  has_many :authorizations

  attr_accessor :invited_secret

  has_secure_password

  validates(
    :name,
    presence: true,
    unless: :invited?,
  )
  validates(
    :role,
    presence: true,
    inclusion: { in: ROLES },
  )
  validates(
    :email,
    presence: true,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: { case_sensitive: false },
  )
  validate :validate_reset_password_token

  before_save :format_email
  before_save :format_name
  before_save :clear_reset_password_digest

  after_save :send_invite_email

  class << self
    def from_omniauth(params, current_user)
      authorization =
        with_authorization(params) do |auth|
          current_user ||= with_user(params)
          auth.user = current_user
        end

      authorization.user
    end

    def from_auth(email:, password:)
      (user = User.find_by(email: email.downcase.strip)) &&
        user.authenticate(password)
    end

    def digest(secret)
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end

      [secret, BCrypt::Password.create(secret, cost: cost)]
    end

    private

    def with_authorization(params)
      Authorization.where(
        provider: params["provider"],
        uid: params["uid"],
      ).first_or_create do |auth|
        auth.provider = params["provider"]
        auth.uid = params["uid"]
        auth.name = params["info"]["name"]
        auth.email = params["info"]["email"]
        auth.token = params["credentials"]["token"]
        auth.secret = params["credentials"]["secret"]
        auth.refresh_token = params["credentials"]["refresh_token"]
        auth.expires_at = Time.zone.at(params["credentials"]["expires_at"]).to_datetime

        yield(auth) if block_given?
      end
    end

    def with_user(params)
      User.where(
        email: params["info"]["email"],
      ).first_or_initialize do |user|
        user.name = params["info"]["name"]
        user.email = params["info"]["email"]
        user.password = SecureRandom.hex

        yield(user) if block_given?
      end
    end
  end

  ROLES.each do |role|
    define_method("#{role}?") do
      self.role == role
    end
  end

  def remember
    SecureRandom.hex.tap do |secret|
      _, digest = self.class.digest(secret)
      update_attribute(:remember_digest, digest)
    end
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def remembered?(secret)
    remember_digest &&
      BCrypt::Password.new(remember_digest).is_password?(secret)
  end

  def reseted?(secret)
    reset_password_digest &&
      BCrypt::Password.new(reset_password_digest).is_password?(secret)
  end

  def invited?
    invited_secret.present?
  end

  private

  def format_email
    self.email = email && email.downcase
  end

  def format_name
    self.name = name && name.titleize
  end

  def clear_reset_password_digest
    return if new_record?
    return unless [email_changed?, password_digest_changed?].any?

    self.reset_password_digest = nil
    self.reset_password_sent_at = nil
  end

  def validate_reset_password_token
    return if reset_password_sent_at.blank?
    return if reset_password_sent_at >= RESET_PASSWORD_WITHIN.ago

    errors.add(:reset_password_sent_at, :expired)
  end

  def send_invite_email
    return unless invited?

    UserMailer.invite_email(self, invited_secret).deliver_later
    self.invited_secret = nil
  end
end
