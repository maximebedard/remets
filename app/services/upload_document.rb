class TextSanitizer
  def sanitize(value)
    ActionView::Helpers::SanitizeHelper.strip_tags(value).downcase
  end
end

class SHA1Hasher
  def hash(value)
    Digest::SHA1.hexdigest(value)
  end
end

class WordTokenizer
  REGEX = /[\w\']+(?:\:\/\/[\w\.\/]+){0,1}/

  def tokenize(value)
    REGEX.match(value)
  end
end

class UploadDocument

  DEFAULT_SHINGLE_COUNT = 128

  def initialize(content_io,
    sanitizer: TextSanitizer.new,
    hasher: SHA1Hasher.new,
    tokenizer: WordTokenizer.new,
    shingle_count: DEFAULT_SHINGLE_COUNT)

    @content_io = content_io
    @sanitizer = sanitizer
    @hasher = hasher
    @tokenizer = tokenizer
    @shingle_count = shingle_count
  end

  def call
    create_document
    upload_document_file
    create_shingles
  end

  private

  def upload_document_file
    File.open(uploaded_url, 'wb') do |file|
      file.write(content)
    end
  end

  def create_document
    @document ||= Document.create!(
      signature: signature,
      url: uploaded_url,
      text: sanitized_content)
  end

  def create_shingles
    @tokenizer.tokenize(sanitized_content).each do |tokens|
    end
  end

  def signature
    @signature ||= @hasher.hash()
  end

  def sanitized_content
    @sanitized_content ||= @sanitizer.sanitize(content)
  end

  def content
    @content ||= @document_io.read
  end

  def uploaded_url
    @uploaded_url ||= Rails.root.join('public', 'uploads', 'documents',
      "#{SecureRandom.hex(10)}-#{@document_io.original_filename.downcase}")
  end
end
