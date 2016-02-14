module Scopes
  class AuthenticatedScope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user)
    end
  end
end
