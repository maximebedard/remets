require "test_helper"

module AcquaintancesProviders
  class EvaluationsTest < ActiveSupport::TestCase
    setup do
      @provider = AcquaintancesProviders::Evaluations.new(
        users(:gaston),
      )
    end

    test "#fetch" do
      assert_equal [], @provider.fetch
    end
  end
end
