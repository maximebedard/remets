module RelationshipBuilders
  class Subscription
    def build(record, email)
      ::Subscription.new(evaluation: record, user: UserInviter.new(email).call)
    end
  end
end
