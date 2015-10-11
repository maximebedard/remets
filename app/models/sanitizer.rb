class Sanitizer
  class << self
    attr_accessor :supported_extensions

    AVAILABLE_SANITIZERS = [
      Sanitizers::DocSanitizer,
      Sanitizers::DocxSanitizer,
      Sanitizers::HtmlSanitizer,
      Sanitizers::PdfSanitizer,
      Sanitizers::TextSanitizer
    ]

    def can_be_sanitized?(ext)
      AVAILABLE_SANITIZERS.flat_map(&:supported_extensions).include?(ext)
    end

    def for_extension(ext, **options)
      AVAILABLE_SANITIZERS.detect do |sanitizer|
        sanitizer.supported_extensions.include?(ext)
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

  def sanitized_content
    sanitize.downcase
  end

  protected

  def sanitize
    raise NotImplementedError
  end
end
