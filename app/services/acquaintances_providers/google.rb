module AcquaintancesProviders
  class Google < Base
    def fetch
      return [] if revoked?
      refresh_token_when_expired

      fetch_acquaintances.map { |data| Acquaintance.new(data) }
    end

    private

    AUTH_HOST_URL = "https://www.googleapis.com".freeze
    AUTH_ENDPOINT_URL = "/oauth2/v3/token".freeze

    REVOKE_HOST_URL = "https://accounts.google.com".freeze
    REVOKE_ENDPOINT_URL = "/o/oauth2/revoke".freeze

    HOST_URL = "https://www.google.com".freeze
    ENDPOINT_PATTERN = "/m8/feeds/contacts/%s/thin".freeze

    # TODO: Implement paging. Default to 150 entries.

    def fetch_acquaintances
      response = connection.get ENDPOINT_PATTERN % user.email,
        "alt" => "json",
        "max-results" => 150
      parse_entries(JSON.parse(response.body)["feed"]["entry"])
    end

    def refresh_token_when_expired
      return unless auth.expired? && auth.refresh_token.present?

      response = fetch_access_token
      data = JSON.parse(response.body)

      auth.update(
        token: data["access_token"],
        expires_at: Time.zone.now + data["expires_in"].seconds,
      )
    end

    def revoked?
      return false if auth.refresh_token.present?

      revoke_connection.get REVOKE_ENDPOINT_URL, token: auth.token
      auth.destroy

      true
    end

    def fetch_access_token
      auth_connection.post AUTH_ENDPOINT_URL,
        client_id: Rails.application.secrets.google_client_id,
        client_secret: Rails.application.secrets.google_client_secret,
        grant_type: "refresh_token",
        refresh_token: auth.refresh_token
    end

    def parse_entries(entries)
      entries.map do |entry|
        {
          name: entry.dig("gd$name", "gd$fullName", "$t"),
          email: entry.dig("gd$email", 0, "address"),
          provider: "google",
        }
      end
    end

    def connection
      @connection ||=
        Faraday.new(HOST_URL) do |f|
          f.request :url_encoded
          f.response :logger, Rails.logger
          f.headers["Content-Type"] = "application/json"
          f.headers["GData-Version"] = "3.0"
          f.headers["Authorization"] = "Bearer #{auth.token}"
          f.adapter Faraday.default_adapter
        end
    end

    def auth_connection
      @auth_connection ||=
        Faraday.new(AUTH_HOST_URL) do |f|
          f.request :url_encoded
          f.response :logger, Rails.logger
          f.adapter Faraday.default_adapter
        end
    end

    def revoke_connection
      @revoke_connection ||=
        Faraday.new(REVOKE_HOST_URL) do |f|
          f.request :url_encoded
          f.response :logger, Rails.logger
          f.adapter Faraday.default_adapter
        end
    end
  end
end
