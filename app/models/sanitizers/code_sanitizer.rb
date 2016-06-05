module Sanitizers
  class CodeSanitizer < Sanitizer
    self.supported_extensions = %w(rb java cpp h hpp sh js)

    def sanitize
      content
    end
  end
end
