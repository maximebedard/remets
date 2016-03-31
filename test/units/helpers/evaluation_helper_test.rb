require "test_helper"

class HandoverHelperTest < ActionView::TestCase
  test "#create_or_update_handover_path returns the create path" do
    assert_equal "/handovers",
      create_or_update_handover_path(Handover.new)
  end

  test "#create_or_update_handover_path returns the update path" do
    handover = handovers(:log121_lab1)
    assert_equal "/handovers/#{handover.uuid}",
      create_or_update_handover_path(handover)
  end
end
