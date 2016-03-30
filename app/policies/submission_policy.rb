class SubmissionPolicy < ApplicationPolicy
  def all?
    true
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def diff?
    true
  end
end
