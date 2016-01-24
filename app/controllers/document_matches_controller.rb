class DocumentMatchesController < ApplicationController
  respond_to :html, :json

  def show
    @document_match = DocumentMatch.find(params[:id])
    authorize(@document_match)

    respond_with(@document_match)
  end
end
