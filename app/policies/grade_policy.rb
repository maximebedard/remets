class GradePolicy < ApplicationPolicy
  def edit?
    true
  end

  def update?
    true
  end
end
