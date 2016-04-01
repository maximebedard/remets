require "test_helper"

class DocxSanitizerTest < ActiveSupport::TestCase
  test "#supported_extensions" do
    assert_equal %w(docx), Sanitizers::DocxSanitizer.supported_extensions
  end

  test "#sanitize" do
    assert_raises NoMethodError do
      Sanitizers::DocxSanitizer.new("").sanitize
    end
  end
end
