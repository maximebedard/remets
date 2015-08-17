class SubmissionsController < ApplicationController
  def show
    Submission.find(params[:id])
  end

  def new
    @submission = Submission.new
  end

  def create
    @submission = SubmissionService.new(document_params).call
    respond_with @submission
  end

  private

  def document_params
    params.require(:document)
          .permit(:content)
  end
end
