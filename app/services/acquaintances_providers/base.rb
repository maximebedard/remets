module AcquaintancesProviders
  class Base
    attr_reader :user, :auth

    def initialize(user, auth = nil)
      @user = user
      @auth = auth
    end

    def fetch
      []
    end
  end
end
