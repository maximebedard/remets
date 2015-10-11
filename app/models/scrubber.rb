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

    def for_extension(ext, content, **options)
      AVAILABLE_SCRUBBERS.detect do |scrubber|
        scrubber.supported_extensions.include?(ext)
      end.new(content, options)
    end

    def for_document(document, **options)
      for_extension(document.extension, document.content, options)
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
