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
      %w(google)
    end

    def authorizations_by_provider(user)
      Hash[available_providers.map { |p| [p, []] }]
        .merge(where(user: user).group_by(&:provider))
    end
  end

  def expired?
    expires_at < Time.zone.now
  end
end
