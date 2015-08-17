class SubmissionComparaison
  attr_reader :submission1
  attr_reader :submission2

  class SameSubmissionError < StandardError
  end

  def initialize(submission1, submission2)
    raise SameSubmissionError if submission1 == submission2

    @submission1 = submission1
    @submission2 = submission2
  end

  def accuracy
    @accuracy ||= calculate_accuracy
  end

  private

  def calculate_accuracy
    num = @submission1.shingles & @submission2.shingles
    denum = @submission1.shingles | @submission2.shingles
    num.size.to_f / denum.size
  end
end
