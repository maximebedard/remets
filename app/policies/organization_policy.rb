class OrganizationPolicy < ApplicationPolicy
  include MustBeAuthenticated

  Scope = Class.new(Scopes::AuthenticatedScope)

  def index?
    true
  end

  def show?
    true
  end

  def edit?
    true
  end

  def update?
    true
  end

  def new?
    true
  end

  def create?
    true
  end
end
