require 'test_helper'

class ScrubberTest < ActiveSupport::TestCase
  class TestScrubber < Scrubber
    def scrub
      content
    end
  end

  setup do
    @scrubber = TestScrubber.new('I AM A PIRATE!')
  end

  test '#scrubbed_content returns the sanitized content' do
    assert_equal 'i am a pirate!', @scrubber.scrubbed_content
  end

  test '#can_be_scrubbed? returns true if there is supported scrubber' do
    assert Scrubber.can_be_scrubbed?('html')
  end

  test '#can_be_scrubbed? returns false if there is no supported scrubber' do
    refute Scrubber.can_be_scrubbed?('yolo')
  end

  test '#for_extension returns the html scrubber' do
    assert_equal Scrubbers::HtmlScrubber,
      Scrubber.for_extension('html')
  end

  test '#for_extension returns the text scrubber' do
    assert_equal Scrubbers::TextScrubber,
      Scrubber.for_extension('txt')
  end

  test '#for_extension returns the doc scrubber' do
    assert_equal Scrubbers::DocScrubber,
      Scrubber.for_extension('doc')
  end

  test '#for_extension returns the docx scrubber' do
    assert_equal Scrubbers::DocxScrubber,
      Scrubber.for_extension('docx')
  end

  test '#for_extension returns the pdf scrubber' do
    assert_equal Scrubbers::PdfScrubber,
      Scrubber.for_extension('pdf')
  end

  test '#for_document returns the appropriate scrubber for the document' do
    document = mock(extension: 'html')
    assert_equal Scrubbers::HtmlScrubber,
      Scrubber.for_document(document)
  end
end
