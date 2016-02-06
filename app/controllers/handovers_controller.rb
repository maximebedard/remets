class HandoversController < ApplicationController
  respond_to :html, :json

  def index
    @handovers = Handover.all
    respond_with(@handovers)
  end

  def edit
    @handover = Handover.find_by!(uuid: params[:uuid])
    respond_with(@handover)
  end

  def update
    @handover = Fingerprinter.new(
      Handover.find_by!(uuid: params[:uuid]),
      handover_params,
    ).call
    respond_with(@handover)
  end

  def new
    @handover = Handover.new
    respond_with(@handover)
  end

  def show
  end

  def create
    @handover = Fingerprinter.new(
      Handover.new,
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
