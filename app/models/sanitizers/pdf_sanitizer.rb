module Sanitizers
  class PdfSanitizer < Sanitizer
    self.supported_extensions = %w(pdf)

    def sanitize
      raise NotImplementedError
    end
  end
end
