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

  test "#remember returns the remember token" do
    assert_not_nil @user.remember
  end

  test "#remember persist the remember_digest" do
    assert_nil @user.remember_digest
    @user.remember
    assert_not_nil @user.reload.remember_digest
  end

  test "#remembered? is true when the token is a password from the remembered digest" do
    SecureRandom.stubs(:hex).returns("pants")

    assert @user.remembered?(@user.remember)
  end

  test "#remembered? is false when the token is not a password from the remembered digest" do
    SecureRandom.stubs(:hex).returns("pants")
    @user.remember

    refute @user.remembered?("potato")
  end

  test "#email is always downcased" do
    user = User.new(
      name: "henry lemieux",
      email: "hENRy@HENRy.com",
      password: "pants",
    )
    user.save(validate: false)

    assert_equal "henry@henry.com", user.email
  end

  test "#name is always titleized" do
    user = User.new(
      name: "henry lemieux",
      email: "hENRy@HENRy.com",
      password: "pants",
    )
    user.save(validate: false)

    assert_equal "Henry Lemieux", user.name
  end

  test "#reseted? is true when the token is a password from the remembered digest" do
    assert users(:clement).reseted?("password")
  end

  test "#reseted? is false when the token is not a password from the remembered digest" do
    refute users(:clement).reseted?("pants")
  end

  test "#reseted? is false when the token is nil" do
    refute users(:henry).reseted?("password")
  end

  test "#clear_reset_password_digest on new record" do
    travel_to(Time.zone.now) do
      user = User.new(
        email: "hENRy@HENRy.com",
        password: "pants",
        reset_password_digest: "pants",
        reset_password_sent_at: 1.day.ago,
      )
      user.save(validate: false)

      assert_not_nil user.reset_password_digest
      assert_equal 1.day.ago, user.reset_password_sent_at
    end
  end

  test "#clear_reset_password_digest on email changed" do
    user = users(:clement)
    user.update!(email: "henry2222@henry.com")
    user.reload

    assert_nil user.reset_password_digest
    assert_nil user.reset_password_sent_at
  end

  test "#clear_reset_password_digest on password digest changed" do
    user = users(:clement)
    user.update!(password: "pantspantspants")
    user.reload

    assert_nil user.reset_password_digest
    assert_nil user.reset_password_sent_at
  end
end
