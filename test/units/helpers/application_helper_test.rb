require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "#active_on_controller returns active when controller name matches user input" do
    assert_equal "active", active_on_controller(@controller.controller_name)
  end

  test "#active_on_controller returns nil when controller name does not match user input" do
    assert_equal nil, active_on_controller("yolo")
  end

  test "#white_background returns white-bg when controller name equals home" do
    @controller.stubs(controller_name: "home")
    assert_equal "white-bg", white_bg?
  end

  test "#white_background returns nil when controller name does not equal home" do
    @controller.stubs(controller_name: "yolo")
    assert_equal nil, white_bg?
  end
end
