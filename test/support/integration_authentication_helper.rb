module Remets
  module IntegrationAuthenticationHelper
    extend ActiveSupport::Concern

    def sign_in(
      email: "rinfrette.gaston@gmail.com",
      password: "password",
      remember_me: false
    )
      get "/auth/new"
      post_via_redirect "/auth", authentication: {
        email: email,
        password: password,
        remember_me: remember_me,
      }
    end
  end
end
