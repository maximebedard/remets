require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:gaston)
  end

  test "#user?" do
    assert @user.user?
    refute users(:pierre).user?
  end

  test "#admin?" do
    refute @user.admin?
    assert users(:pierre).admin?
  end

  test "#remember sets the remember token" do
    token = @user.remember

    assert_not_nil token
    assert_equal token, @user.remember_token
  end

  test "#remember persist the remember_digest" do
    assert_nil @user.remember_digest
    @user.remember
    assert_not_nil @user.reload.remember_digest
  end

  test "#remembered? is true when the token is a password from the remembered digest" do
    SecureRandom.stubs(:urlsafe_base64).returns("pants")

    assert @user.remembered?(@user.remember)
  end

  test "#remembered? is false when the token is not a password from the remembered digest" do
    SecureRandom.stubs(:urlsafe_base64).returns("pants")
    @user.remember

    refute @user.remembered?("potato")
  end
end
