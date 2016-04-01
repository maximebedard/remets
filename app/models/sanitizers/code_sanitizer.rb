module Sanitizers
  class CodeSanitizer < Sanitizer
    self.supported_extensions = %w(rb java cpp c h hpp sh js)

    def sanitize
      content
    end
  end
end
