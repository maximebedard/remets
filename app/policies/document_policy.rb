class DocumentPolicy < ApplicationPolicy
  def show?
    admin? || owner? || handover_creator?
  end

  def download?
    admin? || owner? || handover_creator?
  end

  def diff?
    # TODO
    true
  end

  private

  delegate :admin?, to: :user

  def owner?
    record.submission.user == user
  end

  def handover_creator?
    record.submission.handover.user == user
  end
end
