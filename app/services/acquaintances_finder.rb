class AcquaintancesFinder
  attr_reader :user, :providers

  def initialize(user)
    @user = user
    @providers = build_providers
  end

  def call
    providers.flat_map(&:fetch).uniq(&:email)
  end

  private

  def build_providers
    build_default_providers + build_external_providers
  end

  def build_default_providers
    [
      AcquaintancesProviders::Evaluations.new(user),
    ]
  end

  def build_external_providers
    user.authorizations.map do |auth|
      "AcquaintancesProviders::#{auth.provider.camelize}"
        .constantize.new(user, auth)
    end
  end
end
