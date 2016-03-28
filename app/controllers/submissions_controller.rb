class SubmissionsController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def all
    @submissions = policy_scope(Submission)
    authorize(@submissions)

    respond_with(@submissions)
  end

  def index
    @submissions = policy_scope(handover.submissions)
    authorize(@submissions)

    respond_with(@submissions)
  end

  def show
    @submission = policy_scope(Submission.where(id: params[:id])).first!
    authorize(@submission)

    respond_with(@submission)
  end

  def new
    @submission = policy_scope(handover.submissions).build
    authorize(@submission)

    respond_with(@submission)
  end

  def create
    @submission = policy_scope(handover.submissions).build
    authorize(@submission)

    Fingerprinter.new(
      @submission,
      submission_params,
    ).call
    respond_with(@submission)
  end

  def diff
    @reference, @compared = Submission.find([params[:id], params[:compared_id]])

    authorize(@reference)
    authorize(@compared)

    respond_with(@reference, @compared)
  end

  private

  def submission_params
    params.fetch(:submission, {})
      .permit(documents_attributes: [:file_ptr])
  end

  def handover
    @handover ||= Handover.find_by!(uuid: params[:handover_uuid])
  end
end
