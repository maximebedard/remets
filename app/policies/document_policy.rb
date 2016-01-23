class DocumentPolicy < ApplicationPolicy
  def initialize(*)
    super
    authenticate!
  end

  def index?
    admin?
  end

  def show?
    admin? || owner? || handover_creator?
  end

  def download?
    admin? || owner? || handover_creator?
  end

  private

  delegate :admin?, to: :user

  def owner?
    record.documentable.user == user
  end

  def handover_creator?
    return true unless record.documentable.is_a?(Submission)

    submission = record.documentable
    submission.handover.user == user
  end
end
