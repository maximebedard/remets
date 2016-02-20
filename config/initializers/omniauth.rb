Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    ENV["GOOGLE_CLIENT_ID"],
    ENV["GOOGLE_CLIENT_SECRET"],
    name: "google",
    scope: "email, profile, contacts.readonly",
    prompt: "select_account"

  OmniAuth.config.logger = Rails.logger

  if Rails.env.test?
    OmniAuth.config.on_failure = proc do |env|
      OmniAuth::FailureEndpoint.new(env).redirect_to_failure
    end
  end
end
