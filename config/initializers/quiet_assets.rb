module QuietAssets
  ASSETS_PATHS = [
    %r[\A/{0,2}#{Rails.application.config.assets.prefix}],
  ].freeze

  KEY = "quiet_assets.old_level".freeze

  def call(env)
    if env["PATH_INFO"] =~ assets_regex
      env[KEY] = Rails.logger.level
      Rails.logger.level = Logger::ERROR
    end

    super(env)
  ensure
    Rails.logger.level = env[KEY] if env[KEY]
  end

  private

  def assets_regex
    @assets_regex ||= /\A(#{ASSETS_PATHS.join("|")})/
  end
end

Rails::Rack::Logger.prepend(QuietAssets) if Rails.env.development?
