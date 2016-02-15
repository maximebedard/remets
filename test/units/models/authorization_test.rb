require "test_helper"

class AuthorizationTest < ActiveSupport::TestCase
  test ".authorization_by_provider" do
    user = users(:henry)
    user.authorizations.destroy_all
    auth1 = user.authorizations.create!(
      provider: "google",
      uid: "12345679",
      token: "5aef9828b569c5492213264062d13f36",
      secret: "05f4344cc973b60725deb2dabf3779ad",
    )
    auth2 = user.authorizations.create!(
      provider: "github",
      uid: "987654321",
      token: "5aef9828b569c5492213264062d13f36",
      secret: "05f4344cc973b60725deb2dabf3779ad",
    )

    Authorization.stubs(available_providers: %i(google github bitbucket))

    assert_equal [[:google, auth1], [:github, auth2], [:bitbucket, nil]],
      Authorization.authorizations_by_provider(user)
  end
end
