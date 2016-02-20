require "test_helper"

module AcquaintancesProviders
  class GithubTest < ActiveSupport::TestCase
    setup do
      @provider = AcquaintancesProviders::Github.new(
        users(:gaston),
      )
    end

    test "#fetch" do
      assert_equal [], @provider.fetch
    end
  end
end
