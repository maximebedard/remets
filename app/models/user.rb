class User < ActiveRecord::Base
  ADMIN_ROLE = "admin".freeze
  USER_ROLE = "user".freeze
  ROLES = [USER_ROLE, ADMIN_ROLE].freeze

  has_many :organizations, through: :user_organizations
  has_many :submissions
  has_many :handovers
  has_many :authorizations

  has_secure_password

  validates(
    :name,
    presence: true,
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
  validates(
    :password,
    presence: true,
    length: { minimum: 6 },
  )

  before_save :format_email
  before_save :format_name

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

    def digest(value)
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end

      BCrypt::Password.create(value, cost: cost)
    end

    private

    def with_authorization(params)
      Authorization.where(
        provider: params["provider"],
        uid: params["uid"],
        token: params["credentials"]["token"],
        secret: params["credentials"]["secret"],
      ).first_or_create do |auth|
        auth.provider = params["provider"]
        auth.uid = params["uid"]
        auth.token = params["credentials"]["token"]
        auth.secret = params["credentials"]["secret"]

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
    SecureRandom.hex.tap do |token|
      update_attribute(:remember_digest, self.class.digest(token))
    end
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def remembered?(token)
    BCrypt::Password.new(remember_digest).is_password?(token)
  end

  private

  def format_email
    email.downcase!
  end

  def format_name
    self.name = name.titleize
  end
end
