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
  end

  def expired?
    expires_at < Time.zone.now
  end
end
