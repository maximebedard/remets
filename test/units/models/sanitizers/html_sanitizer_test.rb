require "test_helper"

class HtmlSanitizerTest < ActiveSupport::TestCase
  test "#supported_extensions" do
    assert_equal %w(htm html xhtml), Sanitizers::HtmlSanitizer.supported_extensions
  end

  test "#sanitized_content" do
    assert_raises NotImplementedError do
      Sanitizers::HtmlSanitizer.new("").sanitized_content
    end
  end
end
