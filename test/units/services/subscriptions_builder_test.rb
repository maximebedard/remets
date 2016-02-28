require "test_helper"

class SubscriptionsBuilderTest < ActiveSupport::TestCase
  setup do
    @handover = handovers(:log121_lab1)
  end

  test "#call replaces the members" do
    SubscriptionsBuilder.new(
      @handover,
      [users(:henry).email, users(:clement).email],
    ).call

    assert_equal 2, @handover.subscriptions.size
    assert_equal ["clement.bisson@gmail.com", "lemieux.henry@gmail.com"],
      @handover.users.pluck(:email).sort
    assert_equal "rinfrette.gaston@gmail.com", @handover.user.email
  end
end
