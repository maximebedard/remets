require "test_helper"

class UserInviterTest < ActiveSupport::TestCase
  test "#call invite a user" do
    user = UserInviter.new(
      "idont@exists.com",
    ).call

    assert_equal "idont@exists.com", user.email
    assert_nil user.name
    assert_not_nil user.invited_secret
    assert_not_nil user.reset_password_digest
    assert_not_nil user.reset_password_sent_at
  end

  test "#call sends a notification email with the secret" do
    assert_difference("ActionMailer::Base.deliveries.size") do
      perform_enqueued_jobs do
        invited_user = UserInviter.new(
          "idont@exists.com",
        ).call

        invited_user.save!
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
        invited_user = UserInviter.new(
          user.email,
        ).call

        assert_equal user, invited_user
        refute invited_user.new_record?
      end
    end
  end
end
