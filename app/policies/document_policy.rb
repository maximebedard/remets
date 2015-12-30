class DocumentPolicy < ApplicationPolicy
  def show?
    owner? || handover_creator?
  end

  def download?
    owner? || handover_creator?
  end

  private

  def owner?
    record.documentable.user == user
  end

  def handover_creator?
    return true unless record.documentable.is_a?(Submission)

    submission = record.documentable
    submission.handover.user == user
  end
end
