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

  def evaluation
    @evaluation ||= Evaluation.find_by!(uuid: params[:evaluation_uuid])
  end

  # TODO: this is ugly, find a better way when there is more time.
  # it's not tested either because yolo
  # def apply_filters(scope)
  #   scope
  #     .where("due_date #{params[:completed] ? '<=' : '>'} ?", Time.zone.now)
  #     .order(due_date: params[:due_date] ? :desc : :asc)
  # end
end
