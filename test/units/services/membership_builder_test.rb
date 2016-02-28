require "test_helper"

class MembershipBuilderTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:ets)
  end

  test "#call replaces the members" do
    MembershipBuilder.new(
      @organization,
      [users(:henry).email, users(:clement).email],
    ).call

    assert_equal 3, @organization.memberships.size
    assert_equal ["clement.bisson@gmail.com", "lemieux.henry@gmail.com", "rinfrette.gaston@gmail.com"],
      @organization.memberships.map { |m| m.user.email } .sort
  end

  test "#call append the organization owner" do
    MembershipBuilder.new(@organization, []).call

    assert_equal 1, @organization.memberships.size
    assert_equal "rinfrette.gaston@gmail.com",
      @organization.memberships.first.user.email
  end
end
