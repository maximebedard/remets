module Sanitizers
  class TextSanitizer < Sanitizer
    self.supported_extensions = %w(txt)

    def sanitize
      content # TODO: actually do some cleanup here...
    end
  end
end
