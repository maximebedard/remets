module Scopes
  class AuthenticatedScope < ApplicationPolicy::Scope
    def initialize(*)
      super
      raise ApplicationPolicy::NotAuthenticatedError unless user.present?
    end

    def resolve
      scope.where(user: user)
    end
  end
end
