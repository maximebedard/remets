require "test_helper"

class OrganizationUpdaterTest < ActiveSupport::TestCase
  setup do
    @organization = Organization.new(user: users(:henry))
    @service = OrganizationUpdater.new(
      @organization,
      name: "Yolo.org",
      memberships: ["idont@exists.com"],
    )
  end

  test "#call build the memberships" do
    assert_difference("Membership.count", 2) do
      @service.call
    end

    memberships_emails = @organization.memberships
      .joins(:user)
      .pluck(:"users.email")

    assert_equal(
      [users(:henry).email, "idont@exists.com"].sort,
      memberships_emails.sort,
    )
  end
end
