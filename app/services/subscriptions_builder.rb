class SubscriptionsBuilder
  def initialize(handover, params)
    @handover = handover
    @params = params
  end

  def call
    subscriptions = []
    subscriptions += build_subscriptions

    handover.subscriptions = subscriptions
  end

  private

  attr_reader :handover, :params

  def build_subscriptions
    Array.wrap(params).map do |email|
      Subscription.new(
        handover: handover,
        user: UserInviter.new(email).call,
      )
    end
  end
end
