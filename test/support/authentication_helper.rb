module Remets
  module AuthenticationHelper
    extend ActiveSupport::Concern

    included do
      setup do
        enable_test_mode
        setup_providers
      end
    end

    def enable_test_mode
      OmniAuth.config.test_mode = true
    end

    def setup_providers
      OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
        provider: "google",
        uid: "123545",
        info: {
          name: "Gaston Rinfrette",
          email: "rinfrette.gaston@gmail.com",
        },
      )
    end

    def mock_auth_request(provider)
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
      request.env["omniauth.auth"]
    end

    def supported_providers
      [:google]
    end
  end
end
