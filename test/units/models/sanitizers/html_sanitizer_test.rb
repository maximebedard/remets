require "test_helper"

class HtmlSanitizerTest < ActiveSupport::TestCase
  setup do
    @sanitizer = Sanitizers::HtmlSanitizer.new("<b>bonjour</b><script>alert('OHAI')</script>")
  end

  test "#supported_extensions" do
    assert_equal %w(htm html xhtml), Sanitizers::HtmlSanitizer.supported_extensions
  end

  test "#sanitize" do
    assert_equal "<b>bonjour</b><script>alert('OHAI')</script>", @sanitizer.sanitize
  end

  test "#safe_sanitize" do
    assert_equal "<b>bonjour</b>alert('OHAI')", @sanitizer.safe_sanitize
  end
end
