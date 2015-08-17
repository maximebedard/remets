require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  setup do
    @submission1 = submissions(:submission1)
    @submission2 = submissions(:submission2)
  end

  test '#compare returns a comparaison object with accuracy' do
    result = @submission1.compare(@submission2)
    assert_in_delta 0.2, result.accuracy
  end

  test '#compare against itself raises' do
    assert_raises SubmissionComparaison::SameSubmissionError do
      @submission1.compare(@submission1)
    end
  end

  test '#compare_all compare against all the other submissions' do
    results = @submission1.compare_all
    assert_equal [0.2], results.map(&:accuracy)
  end
end
