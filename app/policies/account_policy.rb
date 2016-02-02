class AccountPolicy < ApplicationPolicy
  include MustBeAuthenticated

  def edit?
    true
  end

  def update?
    true
  end
end
