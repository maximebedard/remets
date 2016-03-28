class DocumentsController < ApplicationController
  include Downloadable
  must_be_authenticated

  respond_to :html, :json

  def show
    authorize(downloadable)

    respond_with(downloadable)
  end

  def compare
    @reference, @compared = policy_scope(Document.where(id: [params[:id], params[:compared_id]]))

    authorize(@reference)
    authorize(@compared)

    respond_with(@reference, @compared)
  end
end
