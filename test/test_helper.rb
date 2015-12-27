unless ENV["SECRET_KEY_BASE"]
  STDERR.puts "\e[31m=> Please load the environment secrets before running the test suite\e[0m"
  exit 1
end

ENV["RAILS_ENV"] ||= "test"

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "mocha/mini_test"
require "pry-byebug"

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

class ActiveSupport::TestCase
  fixtures :all

  include ActionDispatch::TestProcess
  include ActiveJob::TestHelper
end
