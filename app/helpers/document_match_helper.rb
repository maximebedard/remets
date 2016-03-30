module DocumentMatchHelper
  def formatted_title(document)
    link_to(document_path(document)) do
      document.file_original_name
    end
  end

  def formatted_diff(document_match)
    DiffPrinter.new(document_match).call
  end
end
