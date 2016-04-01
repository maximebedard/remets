require "test_helper"

class PdfSanitizerTest < ActiveSupport::TestCase
  test "#supported_extensions" do
    assert_equal %w(pdf), Sanitizers::PdfSanitizer.supported_extensions
  end

  test "#sanitize" do
    assert_raises NoMethodError do
      Sanitizers::PdfSanitizer.new("").sanitize
    end
  end
end
