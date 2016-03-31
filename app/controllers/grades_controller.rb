class GradesController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def edit
    policy_scope(grade)
    authorize(grade)
    respond_with(grade)
  end

  def update
    policy_scope(grade)
    authorize(grade)

    respond_with(
      grade,
      location: grade.update(grade_params) && submission_path(submission),
    )
  end

  private

  def grade_params
    params
      .require(:grade)
      .permit(:result, :comments, :reference_documents_attributes)
  end

  def submission
    @submission ||= Submission.find(params[:submission_id])
  end

  def grade
    @grade ||= (submission.grade || submission.build_grade)
  end
end
