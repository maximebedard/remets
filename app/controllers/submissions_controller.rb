class SubmissionsController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def all
    @submissions = current_user.submissions
    authorize(@submissions)

    respond_with(@submissions)
  end

  def index
    @submissions = evaluation.submissions.where(user: current_user)
    authorize(@submissions)

    respond_with(@submissions)
  end

  def show
    @submission = current_user.submissions.find(params[:id])
    respond_with(@submission)
  end

  def new
    @submission = evaluation.submissions.where(user: current_user).new
    authorize(@submission)

    respond_with(@submission)
  end

  def create
    @submission = evaluation.submissions.where(user: current_user).new
    authorize(@submission)

    @submission.update(submission_params)
    respond_with(@submission)
  end

  def diff
    @reference, @compared = Submission.find([params[:id], params[:compared_id]])
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
