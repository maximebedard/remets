class DocumentsController < ApplicationController
  def index
  end

  def new
  end

  def create
    @document = UploadDocument.new(document_params[:content])
    respond_with @document
  end

  private

  def document_params
    params.require(:document).permit(:content)
  end
end
