class SubmissionsController < ApplicationController
  def index
    Submission.all
  end

  def show
    Submission.find(params[:id])
  end

  def new
    @submission = Submission.new
  end

  def create
    @submission = SubmissionCreationService.new(submission_params).call
    render action: :new, status: :created
  end

  private

  def submission_params
    params.require(:submission)
          .permit(documents_attributes:[:file])
  end
end
