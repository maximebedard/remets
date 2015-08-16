class SubmissionDuplicationService
  def initialize(submission)
    @submission = submission
  end

  def call
    if exact_matches = find_exact_matches
      return exact_matches
    end

  end
end
