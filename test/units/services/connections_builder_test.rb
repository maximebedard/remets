require "test_helper"

class ConnectionsBuilderTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:ets)
    @provider = ConnectionsProviders::MembershipProvider.new
    @service = ConnectionsBuilder.new(
      @organization,
      [users(:henry).email, users(:clement).email],
      provider: @provider,
    )
  end

  test "#call replaces the members" do
    @organization.memberships = @service.call

    assert_equal 2, @organization.memberships.size
    assert_equal ["clement.bisson@gmail.com", "lemieux.henry@gmail.com"],
      @organization.users.pluck(:email).sort
  end

  test "#call append the organization owner" do
    @organization.memberships = @service.call(
      include_owner: true,
    )

    assert_equal 3, @organization.memberships.size
    assert_equal ["clement.bisson@gmail.com", "lemieux.henry@gmail.com", "rinfrette.gaston@gmail.com"],
      @organization.users.pluck(:email).sort
  end
end
