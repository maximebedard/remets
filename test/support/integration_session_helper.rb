module Remets
  module IntegrationSessionHelper
    extend ActiveSupport::Concern

    def sign_in(
      user,
      password: "password",
      remember_me: false
    )
      authentication_params = {
        email: user.email,
        password: password,
        remember_me: remember_me,
      }

      get "/auth/new"
      post "/auth", params: { authentication: authentication_params }
      follow_redirect!
    end
  end
end
