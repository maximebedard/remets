class AccountPolicy < ApplicationPolicy
  include MustBeAuthenticated

  def show?
    true
  end

  def edit?
    true
  end

  def update?
    true
  end
end
