class SubmittedDocumentsController < ApplicationController
  must_be_authenticated

  def show
    @submitted_document = policy_scope(SubmittedDocument.where(id: params[:id])).first!
    authorize(@submitted_document)

    respond_with(@submitted_document)
  end

  def diff
    @reference, @compared = SubmittedDocument.find([params[:id], params[:compared_id]])

    authorize(@reference)
    authorize(@compared)

    respond_with(@reference, @compared)
  end
end
