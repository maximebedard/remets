module Sanitizers
  class TextSanitizer < Sanitizer
    self.supported_extensions = %w(txt text rtf)

    def sanitize
      content.strip
    end
  end
end
