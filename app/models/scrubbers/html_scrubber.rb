module Scrubbers
  class HtmlScrubber < Scrubber
    include ActionView::Helpers::SanitizeHelper

    self.supported_extensions = ['htm', 'html', 'xhtml']

    def scrub
      strip_tags(sanitize(content))
    end
  end
end
