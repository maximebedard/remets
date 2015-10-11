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

  test '#for_extension returns the html scrubber' do
    assert_instance_of Scrubbers::HtmlScrubber,
      @scrubber.class.for_extension('html', 'test')
  end

  test '#for_extension returns the text scrubber' do
    assert_instance_of Scrubbers::TextScrubber,
      @scrubber.class.for_extension('txt', 'test')
  end

  test '#for_extension returns the doc scrubber' do
    assert_instance_of Scrubbers::DocScrubber,
      @scrubber.class.for_extension('doc', 'test')
  end

  test '#for_extension returns the docx scrubber' do
    assert_instance_of Scrubbers::DocxScrubber,
      @scrubber.class.for_extension('docx', 'test')
  end

  test '#for_extension returns the pdf scrubber' do
    assert_instance_of Scrubbers::PdfScrubber,
      @scrubber.class.for_extension('pdf', 'test')
  end

  test '#for_document returns the appropriate scrubber for the document' do
    document = mock(extension: 'html', content: 'test')
    assert_instance_of Scrubbers::HtmlScrubber,
      @scrubber.class.for_document(document)
  end
end
