module Remets
  module AuthenticationHelper
    extend ActiveSupport::Concern

    included do
      OmniAuth.config.test_mode = true
    end

    def mock_auth_failure(provider, message = :invalid_credentials)
      OmniAuth.config.mock_auth[provider] = message
    end

    def mock_auth_request_failure(provider, message = :invalid_credentials)
      request.env["omniauth.auth"] = mock_auth_failure(provider, message)
    end

    def mock_auth(provider, **options)
      OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
        provider: provider,
        **options,
      )
    end

    def mock_auth_request(provider, **options)
      request.env["omniauth.auth"] = mock_auth(provider, options)
    end

    def mock_auth_for(provider, user:)
      mock_auth(
        provider,
        uid: user.uid,
        info: user.attributes.symbolize_keys.slice(:name, :email),
      )
    end

    def mock_auth_request_for(provider, user:)
      request.env["omniauth.auth"] = mock_auth_for(provider, user: user)
    end

    def self.auth_providers
      [:google]
    end
  end
end
