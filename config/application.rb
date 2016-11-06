require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module Remets
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq
    config.responders.flash_keys = %i(success danger)
    config.autoload_paths += %W(
      #{config.root}/app/jobs/concerns
    )
  end
end
