module Remets
  module_function

  def redis_url
    secrets.redis_url.present? ? URI(secrets.redis_url) : nil
  end

  def redis
    @redis ||= Redis.new(
      url: redis_url.to_s.presence,
      logger: Rails.logger,
    )
  end
end
