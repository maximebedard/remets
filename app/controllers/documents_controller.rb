class DocumentsController < ApplicationController
  include Downloadable
  must_be_authenticated

  respond_to :html, :json

  def show
    @document = policy_scope(Document.where(id: params[:id])).first!
    authorize(@document)

    respond_with(@document)
  end

  def diff
    @reference, @compared = Document.find([params[:id], params[:compared_id]])

    authorize(@reference)
    authorize(@compared)

    respond_with(@reference, @compared)
  end
end
