class OrganizationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:user_organizations)
        .where(user_organizations: { user: user })
    end
  end

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

  def leave?
    true
  end
end
