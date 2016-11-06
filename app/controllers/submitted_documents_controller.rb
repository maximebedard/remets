class SubmittedDocumentsController < ApplicationController
  must_be_authenticated

  respond_to :html, :json

  def show
    @submitted_document = SubmittedDocument.find(params[:id])
    respond_with(@submitted_document)
  end

  def diff
    @reference, @compared = SubmittedDocument.find([params[:id], params[:compared_id]])
    respond_with(@reference, @compared)
  end
end
