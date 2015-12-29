require "test_helper"

class DocxSanitizerTest < ActiveSupport::TestCase
  test "#supported_extensions" do
    assert_equal %w(docx), Sanitizers::DocxSanitizer.supported_extensions
  end

  test "#sanitized_content" do
    assert_raises NotImplementedError do
      Sanitizers::DocxSanitizer.new("").sanitized_content
    end
  end
end
