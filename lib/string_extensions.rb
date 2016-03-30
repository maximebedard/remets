module StringExtensions
  def reverse_index(match, offset = 0)
    reverse_offset = size - offset
    return unless index = reverse.index(match, reverse_offset)

    temp = offset + reverse_offset - index
    temp < 0 ? 0 : temp
  end
end

String.include(StringExtensions)
