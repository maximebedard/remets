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
      .take(r_ranges.size) # this is shit, but I have not idea how to fix it... FML

    r_ranges, c_ranges = grow_ranges(r_ranges, c_ranges)

    r_ranges = merge_overlapping_ranges(r_ranges)
    c_ranges = merge_overlapping_ranges(c_ranges)

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
    content_tag(:code) do
      highlight(content, range)
    end
  end

  def highlight(content, range)
    highlighted_content = content.dup
    highlighted_content[range] = "<mark>#{highlighted_content[range]}</mark>"
    highlighted_content.html_safe
  end

  def merge_overlapping_ranges(ranges)
    ranges.inject([]) do |memo, range|
      if !memo.empty? && memo.last.overlaps?(range)
        memo[0...-1] + [merge_range(memo.last, range)]
      else
        memo + [range]
      end
    end
  end

  def merge_range(a, b)
    [a.begin, b.begin].min..[a.end, b.end].max
  end

  def grow_ranges(ranges_1, ranges_2)
    ranges_1.zip(ranges_2)
      .map { |r_1, r_2| grow_range(r_1, r_2) }
      .transpose
  end

  def grow_range(r_1, r_2)
    r_1, r_2 = rgrow(r_1, r_2)
    r_1, r_2 = lgrow(r_1, r_2)

    [r_1, r_2]
  end

  def rgrow(range_1, range_2)
    offsets = offsets_for(
      reference.sanitized_content[range_1.end..-1],
      compared.sanitized_content[range_2.end..-1],
    )

    [
      Range.new(range_1.begin, range_1.end + offsets[0]),
      Range.new(range_2.begin, range_2.end + offsets[1]),
    ]
  end

  def lgrow(range_1, range_2)
    offsets = offsets_for(
      reference.sanitized_content[0..range_1.begin].reverse,
      compared.sanitized_content[0..range_2.begin].reverse,
    )

    [
      Range.new(range_1.begin - offsets[0], range_1.end),
      Range.new(range_2.begin - offsets[1], range_2.end),
    ]
  end

  def offsets_for(content_1, content_2)
    tokens_1 = ContentTokenizer.tokenize(content_1)
    tokens_2 = ContentTokenizer.tokenize(content_2)

    similar_tokens = tokens_1.zip(tokens_2)
      .take_while { |(_, c_1), (_, c_2)| c_1 == c_2 }
      .last

    similar_tokens ||= [[0], [0]]
    [similar_tokens[0][0], similar_tokens[1][0]]
  end

  # A range is a tuple of the starting position and final positions of fingerprints
  # that are close to each others.
  def ranges_from(windows, fingerprints, window_size: 4)
    windows
      .select { |_, f| fingerprints.include?(f) }
      .map(&:first)
      .chunk_while { |i, j| i + window_size >= j }
      .map(&:minmax)
      .map { |args| Range.new(*args) }
      .select { |i| i.size >= window_size }
  end
end
