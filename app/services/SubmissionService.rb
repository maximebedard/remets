class TextScrubber
  include ActionView::Helpers::SanitizeHelper

  def sanitize(value)
    super(value).downcase
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

class SubmissionService
  DEFAULT_SHINGLE_COUNT = 128
  DEFAULT_MODULO = 3

  attr_reader :document
  attr_reader :shingles

  def initialize(submission_params,
    scrubber: TextScrubber.new,
    hasher: SHA1Hasher.new,
    tokenizer: WordTokenizer.new,
    shingle_count: DEFAULT_SHINGLE_COUNT,
    modulo: DEFAULT_MODULO)

    @submission_params = submission_params
    @scrubber = scrubber
    @hasher = hasher
    @tokenizer = tokenizer
    @shingle_count = shingle_count
    @modulo = modulo
  end

  def call
    create_submission
    create_shingles
  end

  private

  def create_document
    @document ||= Submission.create!(@submission_params)
  end

  def create_shingles
    # @tokenizer.tokenize(sanitized_content).each do |tokens|
    #   byebug
    # end
  end
end
