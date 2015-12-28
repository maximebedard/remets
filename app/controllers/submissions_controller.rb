class SubmissionsController < ApplicationController
  respond_to :html, :json

  def index
    @submissions = Submission.all
    respond_with(@submissions)
  end

  def show
    @submission = Submission.find(params[:id])
    respond_with(@submission)
  end

  def new
    @submission = Submission.new
    respond_with(@submission)
  end

  def create
    @submission = Fingerprinter.new(
      Submission.new,
      submission_params,
    ).call
    respond_with(@submission)
  end

  private

  def submission_params
    params.require(:submission)
      .permit(documents_attributes: [:file_ptr])
  end
end
