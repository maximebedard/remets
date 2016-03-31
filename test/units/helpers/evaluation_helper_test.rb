require "test_helper"

class EvaluationHelperTest < ActionView::TestCase
  test "#create_or_update_evaluation_path returns the create path" do
    assert_equal "/evaluations",
      create_or_update_evaluation_path(Evaluation.new)
  end

  test "#create_or_update_evaluation_path returns the update path" do
    evaluation = evaluations(:log121_lab1)
    assert_equal "/evaluations/#{evaluation.uuid}",
      create_or_update_evaluation_path(evaluation)
  end
end
