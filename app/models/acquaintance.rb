class Acquaintance
  include ActiveModel::Model

  attr_accessor :email, :name, :provider

  class << self
    def load_from_cache(user)
      acquaintances = Rails.cache.read("acquaintances:#{user.id}")

      AcquaintanceFindingJob.perform_later(user) if acquaintances.nil?
      acquaintances || []
    end

    def save_to_cache(user, acquaintances)
      Rails.cache.write(
        "acquaintances:#{user.id}",
        acquaintances,
        expires_in: 1.day,
      )
    end

    def from_user(user)
      new(
        name: user.name,
        email: user.email,
      )
    end
  end
end
