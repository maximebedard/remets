require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "#active_on_helper returns active when controller name matches user input" do
    assert_equal "active", active_on_controller(@controller.controller_name)
  end

  test "#active_on_helper returns nil when controller name does not match user input" do
    assert_equal nil, active_on_controller("yolo")
  end
end
