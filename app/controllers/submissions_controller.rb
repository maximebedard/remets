class SubmissionsController < ApplicationController
  respond_to :html, :json

  def all
    @submissions = policy_scope(Submission.all)
    authorize(@submissions)

    respond_with(@submissions)
  end

  def index
    @submissions = policy_scope(
      Handover.find_by(uuid: params[:handover_uuid]).submissions,
    )
    authorize(@submissions)

    respond_with(@submissions)
  end

  def show
    @submission = policy_scope(Submission.where(id: params[:id])).first!
    authorize(@submission)

    respond_with(@submission)
  end

  def new
    @submission = Submission.new
    authorize(@submission)

    respond_with(@submission)
  end

  def create
    @submission = Submission.new
    authorize(@submission)

    @submission = Fingerprinter.new(
      @submission,
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
