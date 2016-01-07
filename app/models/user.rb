class User < ActiveRecord::Base
  ADMIN_ROLE, USER_ROLE = %w(admin user).map(&:freeze)
  ROLES = [ADMIN_ROLE, USER_ROLE].freeze

  validates :name, :email, :uid, :provider, :role, presence: true
  validates :role, inclusion: { in: ROLES }

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
