class Scrubber
  class << self
    attr_accessor :supported_extensions

    AVAILABLE_SCRUBBERS = [
      Scrubbers::DocScrubber,
      Scrubbers::DocxScrubber,
      Scrubbers::HtmlScrubber,
      Scrubbers::PdfScrubber,
      Scrubbers::TextScrubber
    ]

    def can_be_scrubbed?(ext)
      AVAILABLE_SCRUBBERS.map(&:supported_extensions)
        .flatten.include?(ext)
    end

    def for_extension(ext, **options)
      AVAILABLE_SCRUBBERS.detect do |scrubber|
        scrubber.supported_extensions.include?(ext)
      end
    end

    def for_document(document, **options)
      for_extension(document.extension, options)
    end
  end

  attr_reader :content,
    :options

  def initialize(content, **options)
    @content = content
    @options = options
  end

  def scrubbed_content
    scrub.downcase
  end

  protected

  def scrub
    raise NotImplementedError
  end
end
