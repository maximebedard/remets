module Remets
  module FixturesHelper
    def password(value = "password")
      BCrypt::Password.create(value, cost: 4)
    end
  end
end

ActiveRecord::FixtureSet.context_class.include Remets::FixturesHelper
