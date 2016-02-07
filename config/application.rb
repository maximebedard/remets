require File.expand_path("../boot", __FILE__)

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Remets
  AUTH_SESSION_KEY = :_remets_user_id
  AUTH_REMEMBER_KEY = "_remets_remember_id".freeze
  AUTH_REMEMBER_TOKEN = "_remets_remember_token".freeze

  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths += %W(
      #{config.root}/app/policies/concerns
      #{config.root}/app/uploaders/concerns
    )
    config.responders.flash_keys = %i(success danger)
  end
end
