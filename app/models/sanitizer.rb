class Sanitizer
  class << self
    attr_accessor :supported_extensions
    attr_reader :available_sanitizers

    def inherited(subclass)
      self.available_sanitizers << subclass
    end

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

  @available_sanitizers = []

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
