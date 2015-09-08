module Remets
  module MockAuthentication
    extend ActiveSupport::Concern

    DEFAULT_OPTIONS = {
      provider: 'google',
      uid: '123545',
      info: {
        name: 'Gaston Rinfrette',
        email: 'rinfrette.gaston@gmail.com'
      }
    }

    included do
      enable_test_mode
    end

    def mock_auth_request(**options)
      options.reverse_merge!(DEFAULT_OPTIONS)
      OmniAuth.config.mock_auth[options[:provider]] = OmniAuth::AuthHash.new(options)
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[options[:provider]]
    end

    def mock_auth_request_with_error(error: :invalid_credential, **options)
      options.reverse_merge!(DEFAULT_OPTIONS)
      OmniAuth.config.mock_auth[options[:provider]] = error
    end

    private

    module ClassMethods
      def enable_test_mode
        OmniAuth.config.test_mode = true
      end
    end
  end
end
