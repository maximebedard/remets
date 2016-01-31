require "test_helper"

class ApplicationHelperTest < ActiveSupport::TestCase
  include ApplicationHelper
  include ActionView::TestCase::Behavior

  test "#active_on_helper returns active when controller name matches user input" do
    setup_with_controller
    assert_equal "active", active_on_controller(@controller.controller_name)
  end

  test "#active_on_helper returns nil when controller name does not match user input" do
    setup_with_controller
    assert_equal nil, active_on_controller(@controller.controller_name + "_NOPE")
  end
end
