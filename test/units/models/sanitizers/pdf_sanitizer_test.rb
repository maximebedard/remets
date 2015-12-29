require "test_helper"

class PdfSanitizerTest < ActiveSupport::TestCase
  test "#supported_extensions" do
    assert_equal %w(pdf), Sanitizers::PdfSanitizer.supported_extensions
  end

  test "#sanitized_content" do
    assert_raises NotImplementedError do
      Sanitizers::PdfSanitizer.new("").sanitized_content
    end
  end
end
