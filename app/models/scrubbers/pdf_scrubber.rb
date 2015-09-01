module Scrubbers
  class PdfScrubber < Scrubber
    self.supported_extensions = ['pdf']

    def scrub
      raise NotImplementedError
    end
  end
end
