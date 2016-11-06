class EvaluationsController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def index
    @evaluations = apply_filters(current_user.evaluations)
    respond_with(@evaluations)
  end

  def show
    @evaluation = current_user.evaluations.find_by!(uuid: params[:uuid])
    respond_with(@evaluation)
  end

  def edit
    @evaluation = current_user.evaluations.find_by!(uuid: params[:uuid])
    respond_with(@evaluation)
  end

  def update
    @evaluation = current_user.evaluations.find_by!(uuid: params[:uuid])

    EvaluationUpdater.new(@evaluation, evaluation_params).call
    @evaluation.save

    respond_with(@evaluation, location: evaluation_path(uuid: @evaluation.uuid))
  end

  def new
    @evaluation = current_user.evaluations.new
    @evaluation.due_date ||= 3.days.from_now.midnight

    respond_with(@evaluation)
  end

  def create
    @evaluation = current_user.evaluations.new

    EvaluationUpdater.new(@evaluation, evaluation_params).call
    @evaluation.save

    respond_with(@evaluation, location: evaluation_path(uuid: @evaluation.uuid))
  end

  def complete
    @evaluation = current_user.evaluations.find_by!(uuid: params[:uuid])

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
