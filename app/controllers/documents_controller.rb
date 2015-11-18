class DocumentsController < ApplicationController
  def show
  end

  def download
    @document = Document.find(document_id)

    if @document.file&.extension == extension
      send_file @document.file_ptr.current_path,
        disposition: :inline
    else
      head :not_found
    end
  end

  private

  def document_id
    params.require(:id)
  end

  def extension
    params.require(:extension)
  end
end
