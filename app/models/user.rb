class User < ActiveRecord::Base
  validates :name, :email, :uid, :provider, presence: true

  def self.from_omniauth(auth)
    where(provider: auth['provider'], uid: auth['uid'])
      .first_or_create!(
        name: auth['info']['name'],
        email: auth['info']['email'],
        uid: auth['uid'],
        provider: auth['provider'],
      )
  end
end
