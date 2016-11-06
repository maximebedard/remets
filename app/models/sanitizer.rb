class Sanitizer
  class << self
    attr_accessor(
      :supported_extensions,
    )

    def can_be_sanitized?(extension)
      available_sanitizers
        .flat_map(&:supported_extensions)
        .include?(extension)
    end

    def for_extension(extension)
      available_sanitizers.detect do |sanitizer|
        sanitizer.supported_extensions.include?(extension)
      end
    end

    def build_for(file, **options)
      for_extension(file.extension).new(file.read_content, **options)
    end

    def available_sanitizers
      [
        Sanitizers::DocSanitizer,
        Sanitizers::DocxSanitizer,
        Sanitizers::HtmlSanitizer,
        Sanitizers::PdfSanitizer,
        Sanitizers::TextSanitizer,
        Sanitizers::CodeSanitizer,
      ]
    end
  end

  attr_reader(
    :content,
    :options,
  )

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
