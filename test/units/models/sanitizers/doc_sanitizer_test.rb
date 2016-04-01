require "test_helper"

class DocSanitizerTest < ActiveSupport::TestCase
  test "#supported_extensions" do
    assert_equal %w(doc), Sanitizers::DocSanitizer.supported_extensions
  end

  test "#sanitize" do
    assert_raises NoMethodError do
      Sanitizers::DocSanitizer.new("").sanitize
    end
  end
end
