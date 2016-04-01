class ContentTokenizer
  class << self
    def tokenize(content)
      content
        .chars
        .each_with_index.map { |c, i| [i, c.downcase] }
        .select { |_, c| c =~ /\w/ }
    end
  end
end
