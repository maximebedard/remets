class SubmittedDocumentPolicy < ApplicationPolicy
  def show?
    admin? || owner? || evaluation_creator?
  end

  def download?
    admin? || owner? || evaluation_creator?
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

  def evaluation_creator?
    record.submission.evaluation.user == user
  end
end
