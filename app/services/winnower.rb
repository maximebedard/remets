class Winnower
  class << self
    def windows_from_content(content, *options)
      new(*options).perform(
        ContentTokenizer.tokenize_and_sanitize(content || "")
      )
    end

    def windows_from_tokens(tokens, *options)
      new(*options).perform(tokens || [])
    end

    def enum_kgrams(indexed_tokens, k: 5)
      n = indexed_tokens.size

      Enumerator.new do |y|
        if n < k
          y << indexed_tokens
        else
          0.upto(n - k) do |i|
            y << indexed_tokens[i, k]
          end
        end
      end
    end
  end

  def perform(tokens)
    return Set.new unless tokens.present?

    fingerprints =
      self.class.enum_kgrams(tokens, k: @kgrams_size).map do |kgram|
        fingerprint(kgram)
      end

    windows =
      self.class.enum_kgrams(fingerprints, k: @window_size).map do |kgram|
        kgram.min_by { |window| window[1] }
      end

    Set.new(windows)
  end

  private

  def initialize(window_size: 4, kgrams_size: 5)
    @window_size = window_size
    @kgrams_size = kgrams_size
  end

  def fingerprint(indexed_tokens)
    indexes, tokens = indexed_tokens.transpose

    fingerprint = hash(tokens.join)

    [indexes.first, fingerprint]
  end

  def hash(value)
    Digest::SHA1.hexdigest(value).last(4).to_i(16)
  end
end
