class OrganizationUpdater
  def initialize(organization, params = {})
    @organization = organization
    @params = params
  end

  def call
    associate_memberships(params.delete(:memberships))

    update_attributes
  end

  private

  attr_reader :organization, :params

  def associate_memberships(memberships_emails)
    memberships = AssociateByEmail
      .new(organization, memberships_emails, builder: RelationshipBuilders::Membership.new)
      .call(include_owner: true)

    organization.memberships = memberships
  end

  def update_attributes
    organization.update(params)
  end
end
