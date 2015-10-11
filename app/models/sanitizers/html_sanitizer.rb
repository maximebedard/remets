module Sanitizers
  class HtmlSanitizer < Sanitizer
    include ActionView::Helpers::SanitizeHelper

    self.supported_extensions = %w(htm html xhtml)

    def sanitize
      strip_tags(sanitize(content))
    end
  end
end
