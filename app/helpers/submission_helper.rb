module SubmissionHelper
  GRADE_MESSAGES = {
    "success" => "Well done! You da real OG with yo %d\%",
    "info" => "Heads up mang! %d\% is pretty good, but you can do better.",
    "danger" => "Oh snap! How do you want to be the best with a grade like %d\%?",
  }.freeze

  def grade_type(grade)
    case grade.result
    when 80..100
      "success"
    when 60..80
      "info"
    else
      "danger"
    end
  end

  def formatted_grade_result(grade)
    GRADE_MESSAGES[grade_type(grade)] % grade.result
  end
end
