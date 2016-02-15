require "test_helper"

class AcquaintancesFinderTest < ActiveSupport::TestCase
  test "#initialize" do
    finder = AcquaintancesFinder.new(users(:gaston))
    assert_equal users(:gaston), finder.user
  end

  test "#initialize loads the default providers" do
  end

  test "#initialize loads the external providers" do
  end

  test "#initialize does not load the external providers when not authorized with any provider" do
  end

  test "#call" do
  end
end
