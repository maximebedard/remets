require 'test_helper'

class AuthenticationsControllerTest < ActionController::TestCase
  test '#passthru renders a provider not found message'
  test '#passthru redirect to create when the provider is google'

  test '#create assigns the session with the current user'
  test '#creates logs in the user if it already exists'
  test '#create creates the user if it does not already exists'

  test '#destroy clears the user session'
  test '#failure renders a failure message'
end
