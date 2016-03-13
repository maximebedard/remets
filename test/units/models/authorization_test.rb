require "test_helper"

class AuthorizationTest < ActiveSupport::TestCase
  test ".available_providers" do
    assert_equal ["google"], Authorization.available_providers
  end

  test "#expired?" do
    refute authorizations(:google_gaston).expired?
  end

  test "#expired? is true when due_date < current time" do
    travel_to(2.hours.from_now) do
      assert authorizations(:google_gaston).expired?
    end
  end
end
