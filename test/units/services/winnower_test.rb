require "test_helper"

class WinnowerTest < ActiveSupport::TestCase
  test "#windows_from_tokens" do
    windows = Winnower.windows_from_tokens(
      [[0, "h"], [1, "e"], [2, "l"], [3, "l"], [4, "o"]],
    )

    assert_equal Set.new([[0, 17229]]),
      windows
  end

  test "#windows_from_tokens with nil returns an empty set" do
    windows = Winnower.windows_from_tokens(nil)

    assert_equal Set.new, windows
  end

  test "#windows_from_content" do
    windows = Winnower.windows_from_content("hello")

    assert_equal Set.new([[0, 17229]]),
      windows
  end

  test "#windows_from_content returns the rightmost hash" do
    windows = Winnower.windows_from_content("A do run run run, a do run run")

    assert_equal Set.new([]), windows
  end

  test "#windows_from_content with nil returns an empty set" do
    windows = Winnower.windows_from_content(nil)

    assert_equal Set.new, windows
  end

  test "#windows_from_content minimize repetition" do
    windows = Winnower.windows_from_content("A do run run run, a do run run")

    assert_equal Set.new([[2, 1966], [5, 23942], [9, 23942], [14, 2887], [20, 1966]]),
      windows
  end
end
