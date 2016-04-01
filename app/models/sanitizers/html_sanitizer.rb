module Sanitizers
  class HtmlSanitizer < Sanitizer
    self.supported_extensions = %w(htm html xhtml)

    def sanitize
      content
    end
  end
end
