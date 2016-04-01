require "test_helper"

class ContentTokenizerTest < ActiveSupport::TestCase
  test "#tokenize returns an array of index based tuples" do
    subject = ContentTokenizer.tokenize("bobo")

    assert_equal [[0, "b"], [1, "o"], [2, "b"], [3, "o"]],
      subject
  end

  test "#tokenize returns an array of index based tuples all in lower case" do
    subject = ContentTokenizer.tokenize("Bobo!!!")

    assert_equal [[0, "b"], [1, "o"], [2, "b"], [3, "o"]],
      subject
  end
end
