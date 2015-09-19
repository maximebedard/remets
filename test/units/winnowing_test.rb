require 'test_helper'

class WinnowingTest < ActiveSupport::TestCase
  setup do
    @service = Winnowing.new
  end

  test '#tokenize' do
    assert_equal \
      [[0, "H"], [1, "e"], [2, "l"], [3, "l"], [4, "o"], [5, "!"]],
      @service.tokenize('Hello!')
  end

  test '#sanitize' do
    assert_equal \
      [[0, "h"], [1, "e"], [2, "l"], [3, "l"], [4, "o"]],
      @service.sanitize(@service.tokenize('Hello!'))
  end

  test '#kgrams' do
    tokens = @service.sanitize(@service.tokenize('Hello!'))
    values = @service.kgrams(tokens, k: 5) { |kgram| kgram }
    assert_equal \
      [
        [[0, "h"], [1, "e"], [2, "l"], [3, "l"], [4, "o"]],
        [[1, "e"], [2, "l"], [3, "l"], [4, "o"]]
      ], values
  end

  test '#fingerprint' do
    tokens = @service.sanitize(@service.tokenize('Hello!'))

    assert_equal [0, 179260513], @service.fingerprint(tokens)
  end

  test '#winnow' do
    assert_equal \
      Set.new([[3, 121158501], [7, 111704193], [9, 13889624], [18, 21619368], [21, 121158501], [23, 207285363]]),
      @service.winnow('A do run run run, a do run run')
  end

  test '#winnow 2 string' do
    a = @service.winnow('A do run run run, a do run run')
    b = @service.winnow('run run')
  end
end
