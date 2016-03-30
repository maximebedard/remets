class HandoverUpdater
  attr_reader :handover, :user, :params

  def initialize(handover, user, params = {})
    @handover = handover
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
    handover.user = user
  end

  def build_subscriptions
    SubscriptionsBuilder.new(
      handover,
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
      handover,
      params_to_update,
    ).call
  end

  def params_to_update
    params.except(:subscriptions, :organization)
  end
end
