require "test_helper"

module AcquaintancesProviders
  class HandoversTest < ActiveSupport::TestCase
    setup do
      @provider = AcquaintancesProviders::Handovers.new(
        users(:gaston),
      )
    end

    test "#fetch" do
      assert_equal [], @provider.fetch
    end
  end
end
