require "test_helper"

class HandoverTest < ActiveSupport::TestCase
  test "#completed? is true after due date" do
    assert handovers(:log550_lab1).completed?
  end

  test "#completed? is false before due date" do
    refute handovers(:log121_lab1).completed?
  end

  test "#completed? is true before due date, but completed manually" do
    handover = handovers(:log121_lab1)
    handover.mark_as_completed = Time.zone.now

    assert handover.completed?
  end
end
