
require "test_helper"

class AuthenticationsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:gaston)
  end

  test "user signs in" do
    open_session do |sess|
      sess.sign_in(users(:gaston))

      assert_equal "/account/profile", sess.path
      assert_equal @user, sess.controller.current_user
      assert_equal @user.id, sess.session[Remets::AUTH_SESSION_KEY]
    end

    open_session do |sess|
      sess.get "/auth/new"
      assert_nil sess.controller.current_user
      assert_nil sess.session[Remets::AUTH_SESSION_KEY]
    end
  end

  test "user signs in, signs out" do
    open_session do |sess|
      sess.sign_in(users(:gaston))

      assert_equal "/account/profile", sess.path
      assert_equal @user, sess.controller.current_user
      assert_equal @user.id, sess.session[Remets::AUTH_SESSION_KEY]

      sess.delete "/auth/destroy"
      sess.follow_redirect!

      assert_equal "/", sess.path
      assert_nil sess.controller.current_user
      assert_nil sess.session[Remets::AUTH_SESSION_KEY]
    end

    open_session do |sess|
      sess.get "/auth/new"
      assert_nil sess.controller.current_user
      assert_nil sess.session[Remets::AUTH_SESSION_KEY]
    end
  end

  test "user signs in, asks to be remembered" do
    open_session do |sess|
      sess.sign_in(users(:gaston), remember_me: true)

      assert_equal "/account/profile", sess.path
      assert_equal @user, sess.controller.current_user
      assert_equal @user.id, sess.session[Remets::AUTH_SESSION_KEY]
      assert_not_nil sess.cookies[Remets::AUTH_REMEMBER_KEY]
      assert_not_nil sess.cookies[Remets::AUTH_REMEMBER_TOKEN]
    end
  end

  test "user signs in, asks to be remembered, log out" do
    open_session do |sess|
      sess.sign_in(users(:gaston), remember_me: true)

      assert_equal "/account/profile", sess.path
      assert_equal @user, sess.controller.current_user
      assert_equal @user.id, sess.session[Remets::AUTH_SESSION_KEY]
      assert_not_nil sess.cookies[Remets::AUTH_REMEMBER_KEY]
      assert_not_nil sess.cookies[Remets::AUTH_REMEMBER_TOKEN]

      sess.delete "/auth/destroy"
      sess.follow_redirect!

      assert_equal "/", sess.path
      assert_nil sess.controller.current_user
      assert_nil sess.session[Remets::AUTH_SESSION_KEY]
      assert_empty sess.cookies[Remets::AUTH_REMEMBER_KEY]
      assert_empty sess.cookies[Remets::AUTH_REMEMBER_TOKEN]
    end
  end
end
