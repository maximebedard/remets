module Sanitizers
  class TextSanitizer < Sanitizer
    self.supported_extensions = %w(txt)

    def sanitize
      content
    end
  end
end
