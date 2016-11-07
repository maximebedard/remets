require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "#active_link? returns active when controller name matches user input" do
    assert_equal "active", active_link?(@controller.controller_name)
  end

  test "#active_link? returns nil when controller name does not match user input" do
    assert_equal nil, active_link?("yolo")
  end
end
