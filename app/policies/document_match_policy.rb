class DocumentMatchPolicy < ApplicationPolicy
  include MustBeAuthenticated

  def show?
    user.admin?
  end
end
