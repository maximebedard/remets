require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "#active_for returns active when controller name matches user input" do
    assert_equal "active", active_for(@controller.controller_name)
  end

  test "#active_for returns nil when controller name does not match user input" do
    assert_equal nil, active_for("yolo")
  end
end
