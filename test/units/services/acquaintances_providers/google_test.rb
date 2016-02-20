require "test_helper"

module AcquaintancesProviders
  module GoogleRequestStubs
    private

    def stub_fetch(access_token, **options)
      stub_request(
        :get,
        "https://www.google.com/m8/feeds/contacts/rinfrette.gaston@gmail.com/thin?alt=json&max-results=150",
      ).with(
        headers:
          {
            "Authorization" => "Bearer #{access_token}",
            "Content-Type" => "application/json",
            "Gdata-Version" => "3.0",
          },
      ).to_return(options)
    end

    def stub_refresh_token(refresh_token, **options)
      new_access_token = SecureRandom.hex
      stub_request(
        :post,
        "https://www.googleapis.com/oauth2/v3/token",
      ).with(
        body: {
          client_id: Rails.application.secrets.google_client_id,
          client_secret: Rails.application.secrets.google_client_secret,
          grant_type: "refresh_token",
          refresh_token: refresh_token,
        },
      ).to_return(
        status: 200,
        body: { "access_token" => new_access_token, "expires_in" => 3600 }.to_json,
      )

      stub_fetch(new_access_token, options)
    end
  end

  class GoogleTest < ActiveSupport::TestCase
    include GoogleRequestStubs

    setup do
      @user = users(:gaston)
      @auth = authorizations(:google_gaston)
      @provider = AcquaintancesProviders::Google.new(
        @user,
        @auth,
      )
    end

    test "#fetch" do
      stub_fetch(
        @auth.token,
        status: 200,
        body: { "feed" => { "entry" => [] } }.to_json,
      )
      assert_equal [], @provider.fetch
    end

    test "#fetch returns a list of acquaintances" do
      stub_fetch(
        @auth.token,
        status: 200,
        body: {
          "feed" => {
            "entry" => [{
              "gd$name" => { "gd$fullName" => { "$t" => "Gaston Rinfrette" } },
              "gd$email" => [{ "address" => "rinfrette@gaston.com" }],
            }],
          },
        }.to_json,
      )

      acquaintances = @provider.fetch

      assert_equal 1, acquaintances.size
      assert_equal "rinfrette@gaston.com", acquaintances[0].email
      assert_equal "Gaston Rinfrette", acquaintances[0].name
      assert_equal "google", acquaintances[0].provider
    end

    test "#fetch with an expired access token refreshes the token before fetching the acquaintances" do
      @auth.expires_at = Time.zone.now - 10.minutes
      stub_refresh_token(
        @auth.refresh_token,
        status: 200,
        body: { "feed" => { "entry" => [] } }.to_json,
      )
      assert_equal [], @provider.fetch
    end
  end
end
