class Authorization < ActiveRecord::Base
  belongs_to :user

  validates(
    :user,
    :provider,
    :uid,
    :token,
    presence: true,
  )

  class << self
    def available_providers
      # TODO: Add github and bitbucket providers
      %i(google)
    end

    def authorizations_by_provider(user)
      # TODO: Optimize this as it's making a shit ton of queries
      available_providers.map { |p| [p, find_by(provider: p, user: user)] }
    end
  end

  def expired?
    expires_at < Time.zone.now
  end
end
