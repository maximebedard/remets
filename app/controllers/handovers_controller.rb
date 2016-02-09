class HandoversController < ApplicationController
  respond_to :html, :json

  def index
    @handovers = policy_scope(Handover.all)
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
    respond_with(@handover)
  end

  def new
    @handover = Handover.new
    authorize(@handover)

    respond_with(@handover)
  end

  def create
    @handover = Handover.new
    authorize(@handover)

    Fingerprinter.new(
      @handover,
      handover_params,
    ).call
    respond_with(@handover)
  end

  private

  def handover_params
    params.require(:handover)
      .permit(
        :title,
        :description,
        reference_documents_attributes: [:file_ptr],
        boilerplate_documents_attributes: [:file_ptr],
      )
  end
end
