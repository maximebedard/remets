class HandoversController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def index
    @handovers = policy_scope(Handover)
    authorize(@handovers)

    respond_with(@handovers)
  end

  def show
    @handover = policy_scope(Handover.where(uuid: params[:uuid])).first!
    authorize(@handover)

    respond_with(@handover)
  end

  def edit
    @handover = policy_scope(Handover.where(uuid: params[:uuid])).first!
    authorize(@handover)

    respond_with(@handover)
  end

  def update
    @handover = policy_scope(Handover.where(uuid: params[:uuid])).first!
    authorize(@handover)

    Fingerprinter.new(
      @handover,
      handover_params,
    ).call
    respond_with(@handover, location: handover_path(uuid: @handover.uuid))
  end

  def new
    @handover = policy_scope(Handover).build
    authorize(@handover)

    respond_with(@handover)
  end

  def create
    @handover = policy_scope(Handover).build
    authorize(@handover)

    Fingerprinter.new(
      @handover,
      handover_params,
    ).call
    respond_with(@handover, location: handover_path(uuid: @handover.uuid))
  end

  private

  def handover_params
    params.require(:handover)
      .permit(
        :title,
        :description,
        :due_date,
        reference_documents_attributes: [:file_ptr],
        boilerplate_documents_attributes: [:file_ptr],
      )
  end
end
