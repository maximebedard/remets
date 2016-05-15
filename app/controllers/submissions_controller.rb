class SubmissionsController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def all
    @submissions = policy_scope(Submission.where(user: current_user))
    authorize(@submissions)

    respond_with(@submissions)
  end

  def index
    @submissions = policy_scope(evaluation.submissions.where(user: current_user))
    authorize(@submissions)

    respond_with(@submissions)
  end

  def show
    @submission = policy_scope(Submission.where(id: params[:id])).first!
    authorize(@submission)

    respond_with(@submission)
  end

  def new
    @submission = policy_scope(evaluation.submissions.where(user: current_user)).build
    authorize(@submission)

    respond_with(@submission)
  end

  def create
    @submission = policy_scope(evaluation.submissions.where(user: current_user)).build
    authorize(@submission)

    @submission.update(submission_params)
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
      .permit(submitted_documents_attributes: [:file_ptr])
  end

  def evaluation
    @evaluation ||= Evaluation.find_by!(uuid: params[:evaluation_uuid])
  end
end
