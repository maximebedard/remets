require "test_helper"

class UserPasswordReseterTest < ActiveSupport::TestCase
  setup do
    @user = users(:henry)
  end

  test "#call updates the user with a reset digest and an exipration" do
    SecureRandom.stubs(hex: "pants")
    UserPasswordReseter.new(
      @user,
    ).call

    @user.reload

    assert_not_nil @user.reset_password_digest
    assert_not_nil @user.reset_password_sent_at
    assert @user.reseted?("pants")
  end

  test "#call sends a notification email with the secret" do
    assert_difference("ActionMailer::Base.deliveries.size") do
      perform_enqueued_jobs do
        UserPasswordReseter.new(
          @user,
        ).call
      end
    end

    invite_email = ActionMailer::Base.deliveries.last
    assert_equal "Remets - Password reset", invite_email.subject
    assert_equal @user.email, invite_email.to[0]
  end
end
