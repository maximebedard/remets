require "test_helper"

class MembershipsBuilderTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:ets)
  end

  test "#call replaces the members" do
    MembershipsBuilder.new(
      @organization,
      [users(:henry).email, users(:clement).email],
    ).call

    assert_equal 3, @organization.memberships.size
    assert_equal ["clement.bisson@gmail.com", "lemieux.henry@gmail.com", "rinfrette.gaston@gmail.com"],
      @organization.users.pluck(:email).sort
  end

  test "#call append the organization owner" do
    MembershipsBuilder.new(@organization, []).call

    assert_equal 1, @organization.memberships.size
    assert_equal "rinfrette.gaston@gmail.com",
      @organization.users.first.email
  end
end
