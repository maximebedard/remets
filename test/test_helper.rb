ENV["RAILS_ENV"] ||= "test"

require "simplecov"
SimpleCov.start

require_relative "../config/environment"
require "rails/test_help"
require "minitest/pride"
require "mocha/mini_test"
require "webmock/minitest"
require "pry-byebug"
require "ruby-prof" if ENV["PROFILE"]

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

WebMock.disable_net_connect!(allow: "codeclimate.com")

class ActiveSupport::TestCase
  fixtures :all

  include ActionDispatch::TestProcess
  include ActiveJob::TestHelper
end

class ActionController::TestCase
  include Remets::SessionHelper
  include Remets::OmniAuthHelper
end

class ActionDispatch::IntegrationTest
  include Remets::IntegrationSessionHelper
end
