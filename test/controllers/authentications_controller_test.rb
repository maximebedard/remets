require 'test_helper'

class AuthenticationsControllerTest < ActionController::TestCase
  test '#create with an existing user' do
    mock_auth_request
    assert_no_difference 'User.count' do
      post :create, provider: :google
    end
    assert_redirected_to '/'
  end

  test '#create with a new user' do
    mock_auth_request(uid: 1234567, info: { name: 'Roger Lemieux', email: 'lemieux.roger@gmail.com' })
    assert_difference 'User.count' do
      post :create, provider: :google
    end
    assert_redirected_to '/'
  end

  test '#destroy' do
    get :destroy
    assert_redirected_to '/'
    assert_nil session[Remets::AUTH_SESSION_KEY]
  end

  test '#failure' do
    skip
  end
end
