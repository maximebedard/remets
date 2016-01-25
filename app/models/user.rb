class User < ActiveRecord::Base
  ADMIN_ROLE = "admin".freeze
  USER_ROLE = "user".freeze
  ROLES = [USER_ROLE, ADMIN_ROLE].freeze

  has_many :organizations, through: :user_organizations
  has_many :submissions
  has_many :handovers

  validates :name, :email, :uid, :provider, :role, presence: true
  validates :role, inclusion: { in: ROLES }
  validates :email, uniqueness: true

  def self.from_omniauth(auth)
    where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.uid = auth["uid"]
      user.provider = auth["provider"]
    end
  end

  ROLES.each do |role|
    define_method("#{role}?") do
      self.role == role
    end
  end
end
