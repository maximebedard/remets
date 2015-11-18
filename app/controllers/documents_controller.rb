class DocumentsController < ApplicationController
  def download
    return unless params[:id]

    @document = Document.find(params[:id])

    if @document.file && @document.file.extension == params[:extension]
      send_file @document.file.url, disposition: :inline
    else
      head :not_found
    end
  end
end
