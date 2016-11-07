require "test_helper"

class ApplicationControllerTest < ActionController::TestCase
  test "#current_user returns the user from the session" do
    session[Remets::AUTH_SESSION_KEY] = users(:gaston)

    assert_equal "rinfrette.gaston@gmail.com", @controller.current_user.email
  end

  test "#current_user returns nil when the session is not present" do
    session.delete(Remets::AUTH_SESSION_KEY)

    assert_nil @controller.current_user
  end

  test "#current_user return the user from the cookies" do
    user = users(:gaston)

    cookies.permanent.signed[Remets::AUTH_REMEMBER_KEY] = user.id
    cookies.permanent[Remets::AUTH_REMEMBER_TOKEN] = user.remember

    assert_equal "rinfrette.gaston@gmail.com", @controller.current_user.email
  end

  test "#current_user= sets the user in the session" do
    @controller.current_user = users(:gaston)

    assert_equal "rinfrette.gaston@gmail.com", @controller.current_user.email
  end

  test "signed_in? is true when the current_user is present" do
    @controller.current_user = users(:gaston)

    assert @controller.signed_in?
  end

  test "signed_in? is false when the current_user is blank" do
    @controller.current_user = nil

    refute @controller.signed_in?
  end

  test "signed_out? is true when the current_user is blank" do
    @controller.current_user = nil

    assert @controller.signed_out?
  end

  test "signed_out? is false when the current_user is present" do
    @controller.current_user = users(:gaston)

    refute @controller.signed_out?
  end
end
