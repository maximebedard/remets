module RelationshipBuilders
  class Membership
    def build(record, email)
      ::Membership.new(organization: record, user: UserInviter.new(email).call)
    end
  end
end
