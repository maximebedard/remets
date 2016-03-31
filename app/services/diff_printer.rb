class DiffPrinter
  include ActionView::Helpers
  include ActionView::Context

  attr_reader :reference, :compared, :fingerprints

  def initialize(document_match)
    @fingerprints = document_match.match.fingerprints
    @reference = document_match.reference_document
    @compared = document_match.compared_document
  end

  def call
    r_ranges = ranges_from(reference.windows, fingerprints)
    c_ranges = ranges_from(compared.windows, fingerprints)

    capture do
      r_ranges.zip(c_ranges).map do |arg|
        concat build_context_diff(*arg)
      end
    end
  end

  def build_context_diff(r_range, c_range)
    capture do
      concat build_context(reference.sanitized_content, r_range)
      concat build_context(compared.sanitized_content, c_range)
    end
  end

  # TODO: Right now the context is the whole content, but it should be a smaller subset.
  def build_context(content, range)
    section = section_from(content, range)

    content_tag(:code) do
      highlight(content, section)
    end
  end

  def highlight(context, section)
    context = context.dup
    context[*section] = "<mark>#{context[*section]}</mark>"
    context.html_safe
  end

  # A section is a range clipped to the beginning and the end of a word.
  def section_from(content, range)
    s_begin = content.reverse_index(/\W/, range[0])
    s_begin ||= 0

    s_length = content.index(/\W/, range[1])
    s_length ||= content.size
    s_length -= s_begin

    [s_begin, s_length]
  end

  # A range is a tuple of the starting position and final positions of fingerprints
  # that are close to each others.
  def ranges_from(windows, fingerprints, kgram_size: 5)
    windows
      .select { |_, f| fingerprints.include?(f) }
      .map(&:first)
      .chunk_while { |i, j| i + kgram_size >= j - 1 }
      .map(&:minmax)
  end
end
