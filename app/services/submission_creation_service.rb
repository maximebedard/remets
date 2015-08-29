class SubmissionCreationService
  DEFAULT_SHINGLE_COUNT = 4
  DEFAULT_ENTROPY = 3

  attr_reader :submission

  def initialize(submission_params,
    scraper: Scraper.new,
    lexer: Lexer.new,
    shingle_count: DEFAULT_SHINGLE_COUNT,
    entropy: DEFAULT_ENTROPY)

    @submission_params = submission_params
    @scraper = scraper
    @lexer = lexer
    @shingle_count = shingle_count
    @entropy = entropy
  end

  def call
    update_document_params

    create_submission
    create_documents
    complete_submission

    submission
  end

  private

  def update_document_params
    documents_params = @submission_params.fetch(:documents_attributes, []).map { |doc| { file: doc } }
    @submission_params.update(documents_attributes: documents_params)
  end

  def create_submission
    @submission = Submission.new(@submission_params)
  end

  def create_documents
    @submission.documents.each do |document|
      sanitized_content = @scraper.text(document.content)

      document.signature = Signature.sign(sanitized_content)
      document.shingles = shingles_for_document(sanitized_content)
    end
  end

  def complete_submission
    @submission.save!
  end

  def shingles_for_document(content)
    shingles = []
    each_shingle(content) do |shingle|
      test = Signature.sign(shingle.join(' '))[0,7].to_i(16)

      if test % @entropy == 0
        shingles << test
      end
    end
    shingles
  end

  # Yields shingles (or n-gram) for the specified content
  def each_shingle(content, &block)
    shingle = []
    @lexer.tokenize(content).each do |token|
      shingle << token
      next if shingle.size != @shingle_count

      yield(shingle)

      shingle.shift
    end
  end
end
