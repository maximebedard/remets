require "test_helper"

class UserInviterTest < ActiveSupport::TestCase
  test "#call creates a new invalid user with a reset digest and expiration" do
    assert_difference("User.count") do
      user = UserInviter.new(
        "idont@exists.com",
      ).call

      assert_equal "idont@exists.com", user.email
      assert_not_nil user.reset_password_digest
      assert_not_nil user.reset_password_sent_at
    end
  end

  test "#call sends a notification email with the secret" do
    assert_difference("ActionMailer::Base.deliveries.size") do
      perform_enqueued_jobs do
        UserInviter.new(
          "idont@exists.com",
        ).call
      end
    end

    invite_email = ActionMailer::Base.deliveries.last
    assert_equal "Remets - Invitation", invite_email.subject
    assert_equal "idont@exists.com", invite_email.to[0]
  end

  test "#call does nothing when the user already exists" do
    assert_no_difference(["User.count", "ActionMailer::Base.deliveries.size"]) do
      perform_enqueued_jobs do
        user = users(:henry)

        assert_equal user, UserInviter.new(
          user.email,
        ).call
      end
    end
  end
end
