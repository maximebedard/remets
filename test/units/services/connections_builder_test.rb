require "test_helper"

class ConnectionsBuilderTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:ets)
    @provider = ConnectionsProviders::MembershipProvider.new
  end

  test "#call replaces the members" do
    ConnectionsBuilder.new(
      @organization,
      [users(:henry).email, users(:clement).email],
      provider: @provider,
    ).call

    assert_equal 3, @organization.memberships.size
    assert_equal ["clement.bisson@gmail.com", "lemieux.henry@gmail.com", "rinfrette.gaston@gmail.com"],
      @organization.users.pluck(:email).sort
  end

  test "#call append the organization owner" do
    ConnectionsBuilder.new(
      @organization,
      [],
      provider: @provider,
    ).call(include_owner: true)

    assert_equal 1, @organization.memberships.size
    assert_equal "rinfrette.gaston@gmail.com",
      @organization.users.first.email
  end
end
