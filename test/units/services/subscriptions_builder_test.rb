require "test_helper"

class SubscriptionsBuilderTest < ActiveSupport::TestCase
  setup do
    @evaluation = evaluations(:log121_lab1)
  end

  test "#call replaces the members" do
    SubscriptionsBuilder.new(
      @evaluation,
      [users(:henry).email, users(:clement).email],
    ).call

    assert_equal 2, @evaluation.subscriptions.size
    assert_equal ["clement.bisson@gmail.com", "lemieux.henry@gmail.com"],
      @evaluation.users.pluck(:email).sort
    assert_equal "rinfrette.gaston@gmail.com", @evaluation.user.email
  end
end
