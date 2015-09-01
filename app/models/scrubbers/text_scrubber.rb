module Scrubbers
  class TextScrubber < Scrubber
    self.supported_extensions = ['txt']

    def scrub
      content # TODO: actually do some cleanup here...
    end
  end
end
