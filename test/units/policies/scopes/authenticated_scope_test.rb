require "test_helper"

module Scopes
  class AuthenticatedScopeTest < ActiveSupport::TestCase
    test "#scope returns only the users records" do
      results = AuthenticatedScope.new(users(:gaston), Organization.all).resolve

      assert_equal 1, results.size
      assert_equal "École de technologie supérieure", results[0].name
    end
  end
end
