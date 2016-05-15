class OrganizationUpdater
  def initialize(organization, params = {})
    @organization = organization
    @params = params
  end

  def call
    build_memberships
    update_attributes
  end

  private

  attr_reader :organization, :params

  def build_memberships
    organization.memberships = ConnectionsBuilder.new(
      organization,
      params.delete(:memberships),
      provider: ConnectionsProviders::MembershipProvider.new,
    ).call(
      include_owner: true,
    )
  end

  def update_attributes
    organization.update_attributes(params)
  end
end
