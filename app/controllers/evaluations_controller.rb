class EvaluationsController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def index
    @evaluations = policy_scope(apply_filters(Evaluation.where(user: current_user)))
    authorize(@evaluations)

    respond_with(@evaluations)
  end

  def show
    @evaluation = policy_scope(Evaluation.where(uuid: params[:uuid])).first!
    authorize(@evaluation)

    respond_with(@evaluation)
  end

  def edit
    @evaluation = policy_scope(Evaluation.where(uuid: params[:uuid], user: current_user)).first!
    authorize(@evaluation)

    respond_with(@evaluation)
  end

  def update
    @evaluation = policy_scope(Evaluation.where(uuid: params[:uuid], user: current_user)).first!
    authorize(@evaluation)

    EvaluationUpdater.new(@evaluation, evaluation_params).call
    @evaluation.save
    respond_with(@evaluation, location: evaluation_path(uuid: @evaluation.uuid))
  end

  def new
    @evaluation = policy_scope(Evaluation.where(user: current_user)).build
    @evaluation.due_date ||= 3.days.from_now.midnight
    authorize(@evaluation)

    respond_with(@evaluation)
  end

  def create
    @evaluation = policy_scope(Evaluation.where(user: current_user)).build
    authorize(@evaluation)

    EvaluationUpdater.new(@evaluation, evaluation_params).call
    @evaluation.save
    respond_with(@evaluation, location: evaluation_path(uuid: @evaluation.uuid))
  end

  def complete
    @evaluation = policy_scope(Evaluation.where(uuid: params[:uuid], user: current_user)).first!
    authorize(@evaluation)

    @evaluation.update(mark_as_completed: Time.zone.now)
    respond_with(@evaluation, location: evaluation_path(uuid: @evaluation.uuid))
  end

  private

  def evaluation_params
    params.require(:evaluation)
      .permit(
        :title,
        :description,
        :due_date,
        :organization,
        subscriptions: [],
        reference_documents_attributes: [:file_ptr],
        boilerplate_documents_attributes: [:file_ptr],
      )
  end

  # TODO: this is ugly, find a better way when there is more time.
  # it's not tested either because yolo
  def apply_filters(scope)
    scope
      .where("due_date #{params[:completed] ? '<=' : '>'} ?", Time.zone.now)
      .order(due_date: params[:due_date] ? :desc : :asc)
  end
end
