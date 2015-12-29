require "test_helper"

class TextSanitizerTest < ActiveSupport::TestCase
  test "#supported_extensions" do
    assert_equal %w(txt), Sanitizers::TextSanitizer.supported_extensions
  end

  test "#sanitized_content" do
    assert_equal "pants", Sanitizers::TextSanitizer.new("pants").sanitized_content
  end
end
