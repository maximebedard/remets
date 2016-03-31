class GradedDocumentPolicy < ApplicationPolicy
  def download?
    true
  end
end
