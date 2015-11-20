module Remets
  module DocumentFileUploadHelper
    def sanitizable_file_upload
      fixture_file_upload('files/documents/file/605975481/text_document1.txt')
    end

    def unsanitizable_file_upload
      fixture_file_upload('files/documents/file/605975485/platypus.jpg')
    end

    def without_extension_file_upload
      fixture_file_upload('files/documents/file/605975486/platypus')
    end
  end
end
