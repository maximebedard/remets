module Remets
  module OmniAuthHelper
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

    def mock_auth_for(provider, user:, authorization: nil)
      authorization ||= user.authorizations.find_by(provider: provider)
      credentials = authorization&.attributes&.symbolize_keys || {}
      info = user.attributes.symbolize_keys

      mock_auth(
        provider,
        uid: credentials[:uid],
        info: info.slice(:name, :email),
        credentials: credentials.slice(:token, :secret, :refresh_token, :expires_at),
      )
    end

    def mock_auth_request_for(provider, user:, authorization: nil)
      request.env["omniauth.auth"] = mock_auth_for(
        provider,
        user: user,
        authorization: authorization,
      )
    end
  end
end
