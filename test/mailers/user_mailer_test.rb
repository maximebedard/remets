require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:henry)
  end

  test "#password_reset_email" do
    email = UserMailer.password_reset_email(
      @user, SecureRandom.hex
    ).deliver_now

    refute ActionMailer::Base.deliveries.empty?

    assert_equal ["from@example.com"], email.from
    assert_equal ["lemieux.henry@gmail.com"], email.to
    assert_equal "Remets - Password reset", email.subject
    assert_equal read_fixture("password_reset_email").join, email.body.to_s
  end

  test "#invite_email" do
    email = UserMailer.invite_email(
      @user, SecureRandom.hex
    ).deliver_now

    refute ActionMailer::Base.deliveries.empty?

    assert_equal ["from@example.com"], email.from
    assert_equal ["lemieux.henry@gmail.com"], email.to
    assert_equal "Remets - Invitation", email.subject
    assert_equal read_fixture("invite_email").join, email.body.to_s
  end
end
