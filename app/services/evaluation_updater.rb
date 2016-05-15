class EvaluationUpdater
  def initialize(evaluation, params = {})
    @evaluation = evaluation
    @params = params
  end

  def call
    build_subscriptions
    build_organization_association
    update_attributes
  end

  private

  attr_reader :evaluation, :params

  def build_subscriptions
    evaluation.subscriptions = ConnectionsBuilder.new(
      evaluation,
      params.delete(:subscriptions),
      provider: ConnectionsProviders::SubscriptionProvider.new,
    ).call
  end

  def build_organization_association
    return unless memberships = evaluation.user.memberships.find_by(
      organization_id: params.delete(:organization),
    )
    params.merge!(organization_id: memberships.organization_id)
  end

  def update_attributes
    evaluation.update_attributes(params)
  end
end
