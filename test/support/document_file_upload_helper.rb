module Remets
  module SanitizedDocumentFileUploadHelper
    def sanitizable_file_upload
      fixture_file_upload("files/documents/text_document1.txt")
    end

    def unsanitizable_file_upload
      fixture_file_upload("files/documents/platypus.jpg")
    end

    def without_extension_file_upload
      fixture_file_upload("files/documents/platypus")
    end

    def empty_file_upload
      fixture_file_upload("files/documents/empty.txt")
    end
  end
end
