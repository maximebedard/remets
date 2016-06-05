require "test_helper"

class SanitizerTest < ActiveSupport::TestCase
  class TestSanitizer < Sanitizer
    def sanitize
      content
    end
  end

  setup do
    @sanitizer = TestSanitizer.new("i am a pirate!<script>alert('ohai');</script>")
  end

  test "#sanitize returns the sanitized content" do
    assert_equal "i am a pirate!<script>alert('ohai');</script>", @sanitizer.sanitize
  end

  test "#safe_sanitize returns the safe sanitized content" do
    assert_equal "i am a pirate!alert('ohai');", @sanitizer.safe_sanitize
  end

  test "#can_be_sanitized? returns true if there is supported Sanitizer" do
    assert Sanitizer.can_be_sanitized?("html")
  end

  test "#can_be_sanitized? returns false if there is no supported Sanitizer" do
    refute Sanitizer.can_be_sanitized?("yolo")
  end

  test "#for_extension returns the html Sanitizer" do
    assert_equal Sanitizers::HtmlSanitizer,
      Sanitizer.for_extension("html")
  end

  test "#for_extension returns the text Sanitizer" do
    assert_equal Sanitizers::TextSanitizer,
      Sanitizer.for_extension("txt")
  end

  test "#for_extension returns the doc Sanitizer" do
    assert_equal Sanitizers::DocSanitizer,
      Sanitizer.for_extension("doc")
  end

  test "#for_extension returns the docx Sanitizer" do
    assert_equal Sanitizers::DocxSanitizer,
      Sanitizer.for_extension("docx")
  end

  test "#for_extension returns the pdf Sanitizer" do
    assert_equal Sanitizers::PdfSanitizer,
      Sanitizer.for_extension("pdf")
  end

  test "#for_document returns the appropriate Sanitizer for the document" do
    document = mock(extension: "html", content: "yolo")
    sanitizer = Sanitizer.build_for(document)

    assert_instance_of Sanitizers::HtmlSanitizer, sanitizer
  end
end
