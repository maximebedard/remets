require "test_helper"

class ContentTokenizerTest < ActiveSupport::TestCase
  test "#sanitize downcases and remove any non alphanumerical chars" do
    subject = ContentTokenizer.sanitize([[0, "B"], [1, " "], [2, "b"], [3, "!"]])

    assert_equal [[0, "b"], [2, "b"]],
      subject
  end

  test "#tokenize returns an array of index based tuples" do
    subject = ContentTokenizer.tokenize("bobo")

    assert_equal [[0, "b"], [1, "o"], [2, "b"], [3, "o"]],
      subject
  end

  test "#tokenize_and_sanitize" do
    subject = ContentTokenizer.tokenize_and_sanitize("Bob est Beau!")

    assert_equal [[0, "b"], [1, "o"], [2, "b"], [4, "e"], [5, "s"], [6, "t"], [8, "b"], [9, "e"], [10, "a"], [11, "u"]],
      subject
  end
end
