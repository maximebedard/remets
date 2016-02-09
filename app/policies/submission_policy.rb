class SubmissionPolicy < ApplicationPolicy
  include MustBeAuthenticated

  Scope = Class.new(Scopes::AuthenticatedScope)

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
end
