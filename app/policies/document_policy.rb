class DocumentPolicy < ApplicationPolicy
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
    record.submission.user == user
  end

  def handover_creator?
    record.submission.handover.user == user
  end
end
