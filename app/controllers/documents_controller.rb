class DocumentsController < ApplicationController
  def index
    @documents = Document.all
    authorize(@documents)
  end

  def show
    @document = Document.find(params[:id])
    authorize(@document)
  end

  def download
    @document = Document.find(params[:id])
    authorize(@document)

    send_file @document.file_ptr.current_path, disposition: :inline
  end
end
