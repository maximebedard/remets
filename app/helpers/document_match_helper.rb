module DocumentMatchHelper
  def formatted_title(document)
    link_to(document_download_path(document.file_ptr)) do
      document.file_original_name
    end
  end

  def formatted_diff(_document_match)
    ""
  end
end
