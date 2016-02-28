class MembershipBuilder
  def initialize(organization, params)
    @organization = organization
    @params = params
  end

  def call
    memberships = []
    memberships += build_memberships
    memberships += build_membership_for_owner

    organization.memberships = memberships
  end

  private

  attr_reader :organization, :params

  def build_memberships
    Array.wrap(params).map do |email|
      Membership.new(
        organization: organization,
        user: UserInviter.new(email).call,
      )
    end
  end

  def build_membership_for_owner
    [
      Membership.new(
        organization: organization,
        user: organization.user,
      ),
    ]
  end
end
