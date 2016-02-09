module Remets
  module IntegrationAuthenticationHelper
    extend ActiveSupport::Concern

    def sign_in(
      user,
      password: "password",
      remember_me: false
    )
      get "/auth/new"
      post_via_redirect "/auth", authentication: {
        email: user.email,
        password: password,
        remember_me: remember_me,
      }
    end
  end
end
