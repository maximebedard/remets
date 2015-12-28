class HandoversController < ApplicationController
  respond_to :html, :json

  def index
    @handovers = Handover.all
    respond_with(@handovers)
  end
end
