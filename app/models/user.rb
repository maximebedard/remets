class User < ActiveRecord::Base
  validates :name, :email, :uid, :provider, presence: true

  def self.from_omniauth(auth)
    where(provider: auth['provider'], uid: auth['uid']).first_or_create do |user|
      user.name = auth['info']['name']
      user.email = auth['info']['email']
      user.uid = auth['uid']
      user.provider = auth['provider']
    end
  end
end
