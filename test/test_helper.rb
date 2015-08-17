ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'
require 'byebug'

class ActiveSupport::TestCase
  fixtures :all

  CarrierWave.root = 'test/fixtures/files'

  include ActionDispatch::TestProcess
end
