module ConnectionsProviders
  class MembershipProvider
    def build(record, email)
      # byebug
      Membership.new(
        organization: record,
        user: UserInviter.new(email).call,
      )
    end
  end
end
