require "test_helper"

class DocSanitizerTest < ActiveSupport::TestCase
  test "#supported_extensions" do
    assert_equal %w(doc), Sanitizers::DocSanitizer.supported_extensions
  end

  test "#sanitized_content" do
    assert_raises NotImplementedError do
      Sanitizers::DocSanitizer.new("").sanitized_content
    end
  end
end
