class DocumentPolicy < ApplicationPolicy
  def index?
    authenticated? && admin?
  end

  def show?
    authenticated? && (admin? || owner? || handover_creator?)
  end

  def download?
    authenticated? && (admin? || owner? || handover_creator?)
  end

  private

  delegate :admin?, to: :user

  def authenticated?
    !user.nil?
  end

  def owner?
    record.documentable.user == user
  end

  def handover_creator?
    return true unless record.documentable.is_a?(Submission)

    submission = record.documentable
    submission.handover.user == user
  end
end
