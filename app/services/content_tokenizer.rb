class ContentTokenizer
  class << self
    def tokenize_and_sanitize(content)
      sanitize(tokenize(content))
    end

    def tokenize(content)
      0.upto(content.size - 1).to_a.zip(content.chars)
    end

    def sanitize(tokens)
      tokens.map { |token| [token[0], token[1].downcase] }
        .select { |token| token[1] =~ /\w/ }
    end
  end
end
