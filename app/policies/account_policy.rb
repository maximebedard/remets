class AccountPolicy < ApplicationPolicy
  def show?
    user.present?
  end

  def edit?
    user.present?
  end

  def update?
    user.present?
  end
end
