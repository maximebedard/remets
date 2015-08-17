class SubmissionCreationService
  DEFAULT_SHINGLE_COUNT = 4
  DEFAULT_MODULO = 3

  attr_reader :submission

  def initialize(submission_params,
    scraper: Scraper.new,
    lexer: Lexer.new,
    shingle_count: DEFAULT_SHINGLE_COUNT,
    modulo: DEFAULT_MODULO)

    @submission_params = submission_params
    @scraper = scraper
    @lexer = lexer
    @shingle_count = shingle_count
    @modulo = modulo
  end

  def call
    create_submission
    create_shingles
    complete_submission

    submission
  end

  private

  def create_submission
    @submission = Submission.new(@submission_params)
    @submission.document_signature = Signature.sign(sanitized_document_content)
  end

  def create_shingles
    shingles = []
    each_shingle(sanitized_document_content) do |shingle|
      test = Signature.sign(shingle.join(' '))[0,7].to_i(16)

      if test % @modulo == 0
        shingles << test
      end
    end

    @submission.shingles = shingles
  end

  def each_shingle(content, &block)
    shingle = []
    @lexer.tokenize(content).each do |token|
      shingle << token
      next if shingle.size != @shingle_count

      yield(shingle)

      shingle.shift
    end
  end

  def complete_submission
    @submission.save!
  end

  def sanitized_document_content
    @scraper.text(@submission.document_content)
  end
end
