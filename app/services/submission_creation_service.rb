class SubmissionCreationService
  DEFAULT_SHINGLE_COUNT = 4
  DEFAULT_ENTROPY = 3

  attr_reader :submission

  def initialize(submission_params,
    tokenizer: Tokenizer.new,
    shingle_count: DEFAULT_SHINGLE_COUNT,
    entropy: DEFAULT_ENTROPY)

    @submission_params = submission_params
    @tokenizer = tokenizer
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
    documents_params =
      @submission_params.fetch(:documents_attributes, []).map do |doc|
        { file: doc }
      end
    @submission_params.update(documents_attributes: documents_params)
  end

  def create_submission
    @submission = Submission.new(@submission_params)
  end

  def create_documents
    @submission.documents.each do |document|
      scrubbed_content = Scrubber.for_document(document).scrubbed_content

      document.signature = Signature.sign(scrubbed_content)
      document.shingles = shingles_for_document(scrubbed_content)
    end
  end

  def complete_submission
    @submission.save!
  end

  def shingles_for_document(content)
    shingles = []
    each_shingles(content) do |shingle|
      # We take only the first 8 bytes
      test = Signature.sign(shingle.join(' '))[0,7].to_i(16)

      if test % @entropy == 0
        shingles << test
      end
    end
    shingles
  end

  # Yields shingles (or n-gram) for the specified content
  def each_shingles(content, &block)
    shingle = []
    @tokenizer.tokenize(content).each do |token|
      shingle << token
      next if shingle.size != @shingle_count

      yield(shingle)

      shingle.shift
    end
  end
end
