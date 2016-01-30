class User < ActiveRecord::Base
  ADMIN_ROLE = "admin".freeze
  USER_ROLE = "user".freeze
  ROLES = [USER_ROLE, ADMIN_ROLE].freeze

  has_many :organizations, through: :user_organizations
  has_many :submissions
  has_many :handovers

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

  attr_reader :remember_token

  class << self
    def from_omniauth(params)
      where(provider: params["provider"], uid: params["uid"]).first_or_create do |user|
        user.uid = params["uid"]
        user.provider = params["provider"]
        user.email = params["info"]["email"]
        user.name = params["info"]["name"]
        user.password = SecureRandom.hex
      end
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
  end

  ROLES.each do |role|
    define_method("#{role}?") do
      self.role == role
    end
  end

  def remember
    @remember_token = SecureRandom.urlsafe_base64.tap do |token|
      update_attribute(:remember_digest, self.class.digest(token))
    end
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
