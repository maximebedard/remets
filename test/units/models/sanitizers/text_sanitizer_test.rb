require "test_helper"

class TextSanitizerTest < ActiveSupport::TestCase
  setup do
    @sanitizer = Sanitizers::TextSanitizer.new("pants   pants!@$$    ")
  end

  test "#supported_extensions" do
    assert_equal %w(txt text rtf), Sanitizers::TextSanitizer.supported_extensions
  end

  test "#sanitize" do
    assert_equal "pants   pants!@$$", @sanitizer.sanitize
  end

  test "#safe_sanitize" do
    assert_equal "pants   pants!@$$", @sanitizer.safe_sanitize
  end
end
