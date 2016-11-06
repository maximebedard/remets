class GradesController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def edit
    @grade = submission.grade
    respond_with(@grade)
  end

  def update
    @grade = submission.build_grade
    respond_with(
      @grade,
      location: @grade.update(grade_params) && submission_path(submission),
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
end
