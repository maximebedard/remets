class HandoversController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def index
    @handovers = policy_scope(apply_filters(Handover.where(user: current_user)))
    authorize(@handovers)

    respond_with(@handovers)
  end

  def show
    @handover = policy_scope(Handover.where(uuid: params[:uuid])).first!
    authorize(@handover)

    respond_with(@handover)
  end

  def edit
    @handover = policy_scope(Handover.where(uuid: params[:uuid], user: current_user)).first!
    authorize(@handover)

    respond_with(@handover)
  end

  def update
    @handover = policy_scope(Handover.where(uuid: params[:uuid], user: current_user)).first!
    authorize(@handover)

    HandoverUpdater.new(@handover, current_user, handover_params).call

    respond_with(@handover, location: handover_path(uuid: @handover.uuid))
  end

  def new
    @handover = policy_scope(Handover.where(user: current_user)).build
    @handover.due_date ||= 3.days.from_now.midnight
    authorize(@handover)

    respond_with(@handover)
  end

  def create
    @handover = policy_scope(Handover.where(user: current_user)).build
    authorize(@handover)

    HandoverUpdater.new(@handover, current_user, handover_params).call

    respond_with(@handover, location: handover_path(uuid: @handover.uuid))
  end

  def complete
    @handover = policy_scope(Handover.where(uuid: params[:uuid], user: current_user)).first!
    authorize(@handover)

    @handover.update(mark_as_completed: Time.zone.now)
    respond_with(@handover, location: handover_path(uuid: @handover.uuid))
  end

  private

  def handover_params
    params.require(:handover)
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
