class EvaluationUpdater
  attr_reader :evaluation, :user, :params

  def initialize(evaluation, user, params = {})
    @evaluation = evaluation
    @user = user
    @params = params
  end

  def call
    assign_owner
    build_subscriptions
    build_organization_association
    fingerprint
  end

  private

  def assign_owner
    evaluation.user = user
  end

  def build_subscriptions
    SubscriptionsBuilder.new(
      evaluation,
      params[:subscriptions],
    ).call
  end

  def build_organization_association
    return unless memberships = user.memberships.find_by(
      organization_id: params[:organization],
    )
    params.merge!(organization_id: memberships.organization_id)
  end

  def fingerprint
    Fingerprinter.new(
      evaluation,
      params_to_update,
    ).call
  end

  def params_to_update
    params.except(:subscriptions, :organization)
  end
end