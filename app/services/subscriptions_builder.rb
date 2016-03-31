class SubscriptionsBuilder
  def initialize(evaluation, params)
    @evaluation = evaluation
    @params = params
  end

  def call
    subscriptions = []
    subscriptions += build_subscriptions

    evaluation.subscriptions = subscriptions
  end

  private

  attr_reader :evaluation, :params

  def build_subscriptions
    Array.wrap(params).map do |email|
      Subscription.new(
        evaluation: evaluation,
        user: UserInviter.new(email).call,
      )
    end
  end
end
