module EvaluationHelper
  def create_or_update_evaluation_path(evaluation)
    return evaluation_path(uuid: evaluation.uuid) if evaluation.uuid.present?
    evaluations_path
  end
end
