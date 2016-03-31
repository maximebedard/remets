require "test_helper"

class SubmissionHelperTest < ActionView::TestCase
  test "#grade_type success" do
    assert_equal "success",
      grade_type(grades(:success))
  end

  test "#grade_type info" do
    assert_equal "info",
      grade_type(grades(:okay))
  end

  test "#grade_type danger" do
    assert_equal "danger",
      grade_type(grades(:failure))
  end

  test "#formatted_grade_result success" do
    assert_equal "Well done! You da real OG with yo 88%.",
      formatted_grade_result(grades(:success))
  end

  test "#formatted_grade_result info" do
    assert_equal "Heads up mang! 65% is pretty good, but you can do better.",
      formatted_grade_result(grades(:okay))
  end

  test "#formatted_grade_result danger" do
    assert_equal "Oh snap! How do you want to be the best with a grade like 44%?",
      formatted_grade_result(grades(:failure))
  end
end
