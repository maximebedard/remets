require "test_helper"

module AcquaintancesProviders
  class BitbucketTest < ActiveSupport::TestCase
    setup do
      @provider = AcquaintancesProviders::Bitbucket.new(
        users(:gaston),
      )
    end

    test "#fetch" do
      assert_equal [], @provider.fetch
    end
  end
end
