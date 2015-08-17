require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  setup do
    @submission1 = submissions(:submission1)
    @submission2 = submissions(:submission2)
  end

  test '#compare returns a comparaison object with the resemblance' do
    result = @submission1.compare(@submission2)
    assert_in_delta 0.2, result.resemblance
  end

  test '#compare against more elaborated corpus' do
    @platypus1 = submissions(:platypus)
    @platypus2 = submissions(:awesome_platypus)
    assert_in_delta 0.489, @platypus1.compare(@platypus2).resemblance
  end

  test '#compare against itself raises' do
    assert_raises SubmissionComparaison::SameSubmissionError do
      @submission1.compare(@submission1)
    end
  end

  test '#compare_all returns comparaisons for all stored submissions' do
    assert_equal 4, Submission.count, <<-MSG
      The submissions.yml has been updated.
      This test needs to be updated accordingly.
    MSG

    results = @submission1.compare_all.map(&:resemblance)
    assert_equal [0.0, 0.0, 0.2], results
  end
end
