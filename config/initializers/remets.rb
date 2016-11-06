module Remets
  AUTH_SESSION_KEY = "_remets_user_id".freeze
  AUTH_REMEMBER_KEY = "_remets_remember_id".freeze
  AUTH_REMEMBER_TOKEN = "_remets_remember_token".freeze
  ORIGIN_KEY = "_remets_origin".freeze

  NotAuthenticatedError = Class.new(StandardError)
end
