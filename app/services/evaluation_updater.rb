class EvaluationUpdater
  def initialize(evaluation, params = {})
    @evaluation = evaluation
    @params = params
  end

  def call
    associate_subscriptions(params.delete(:subscriptions))
    associate_organization(params.delete(:organization))

    update_attributes
  end

  private

  attr_reader :evaluation, :params

  def associate_subscriptions(subscription_emails)
    subscriptions = AssociateByEmail
      .new(evaluation, subscription_emails, builder: RelationshipBuilders::Subscription.new)
      .call

    evaluation.subscriptions = subscriptions
  end

  def associate_organization(organization_id)
    membership = evaluation
      .user
      .memberships
      .find_by(organization_id: organization_id)

    evaluation.organization = membership && membership.organization
  end

  def update_attributes
    evaluation.update(params)
  end
end
