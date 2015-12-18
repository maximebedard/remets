require File.expand_path("../boot", __FILE__)

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Remets
  AUTH_SESSION_KEY = :_remets_user_id

  class Application < Rails::Application
  end
end
