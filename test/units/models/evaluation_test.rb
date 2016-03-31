require "test_helper"

class EvaluationTest < ActiveSupport::TestCase
  test "#completed? is true after due date" do
    assert evaluations(:log550_lab1).completed?
  end

  test "#completed? is false before due date" do
    refute evaluations(:log121_lab1).completed?
  end

  test "#completed? is true before due date, but completed manually" do
    evaluation = evaluations(:log121_lab1)
    evaluation.mark_as_completed = Time.zone.now

    assert evaluation.completed?
  end
end
