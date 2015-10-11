class HandoversController < ApplicationController
  def index
    @handovers = Handover.all
    respond_with(@handovers)
  end
end
