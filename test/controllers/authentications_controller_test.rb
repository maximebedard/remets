require 'test_helper'

class AuthenticationsControllerTest < ActionController::TestCase
  include Remets::AuthenticationHelper

  test '#create with an existing user' do
    mock_auth_request(:google)
    assert_no_difference 'User.count' do
      post :create, provider: :google
    end
    assert_equal session[Remets::AUTH_SESSION_KEY], users(:gaston).id
    assert_redirected_to '/'
  end

  test '#create with a new user' do
    mock_auth_request(:google).update(uid: '1234567', info: { name: 'Roger Lemieux', email: 'lemieux.roger@gmail.com' })
    assert_difference 'User.count' do
      post :create, provider: :google
    end
    assert_equal session[Remets::AUTH_SESSION_KEY], User.last.id
    assert_redirected_to '/'
  end

  test '#destroy' do
    get :destroy
    assert_redirected_to '/'
    assert_nil session[Remets::AUTH_SESSION_KEY]
  end
end