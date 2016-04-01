class Sanitizer
  class << self
    attr_accessor :supported_extensions
    attr_reader :available_sanitizers

    def can_be_sanitized?(ext)
      available_sanitizers.flat_map(&:supported_extensions).include?(ext)
    end

    def for_extension(ext)
      available_sanitizers.detect do |sanitizer|
        sanitizer.supported_extensions.include?(ext)
      end
    end

    def for_document(document)
      for_extension(document.extension)
    end
  end

  @available_sanitizers = [
    Sanitizers::DocSanitizer,
    Sanitizers::DocxSanitizer,
    Sanitizers::HtmlSanitizer,
    Sanitizers::PdfSanitizer,
    Sanitizers::TextSanitizer,
    Sanitizers::CodeSanitizer,
  ]

  attr_reader :content,
    :options

  def initialize(content, **options)
    @content = content
    @options = options
  end

  def safe_sanitize
    SafeSanitizer.new(self).call
  end

  class SafeSanitizer
    include ActionView::Helpers::SanitizeHelper

    def initialize(sanitizer)
      @sanitizer = sanitizer
    end

    def call
      sanitize(@sanitizer.sanitize)
    end
  end
end
