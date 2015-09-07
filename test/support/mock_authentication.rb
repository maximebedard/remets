module Remets
  module MockAuthentication
    extend ActiveSupport::Concern

    included do
      enable_test_mode
      mock_providers
    end

    def sign_in_with(user)
      session[Remets::AUTH_SESSION_KEY] = user.id
    end

    def sign_out
      session.delete(Remets::AUTH_SESSION_KEY)
    end

    private

    module ClassMethods
      def enable_test_mode
        OmniAuth.config.test_mode = true
      end

      def mock_providers
        OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
          provider: 'google',
          uid: '123545',
          info: {
            name: 'Gaston Rinfrette',
            email: 'rinfrette.gaston@gmail.com'
          }
        })
      end
    end
  end
end
