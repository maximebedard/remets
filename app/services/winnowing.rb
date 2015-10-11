class Winnowing
  def initialize(window_size: 4, kgrams_size: 5)
    @window_size = window_size
    @kgrams_size = kgrams_size
  end

  def perform(content)
    sanitized_tokens = sanitize(tokenize(content))

    fingerprints =
      kgrams(sanitized_tokens, k: @kgrams_size) do |kgram|
        fingerprint(kgram)
      end

    windows =
      kgrams(fingerprints, k: @window_size) do |kgram|
        kgram.min_by { |window| window[1] }
      end

    windows
  end

  private

  def tokenize(value)
    0.upto(value.size - 1).to_a.zip(value.chars)
  end

  def sanitize(indexed_tokens)
    indexed_tokens.map { |token| [token[0], token[1].downcase] }
      .select { |token| token[1] =~ /\w/ }
  end

  def kgrams(indexed_tokens, k: 5)
    n = indexed_tokens.size
    ret = []
    if n < k
      ret << (yield indexed_tokens)
    else
      0.upto(n - k + 1) do |i|
        ret << (yield indexed_tokens[i, (i + k)])
      end
    end
    ret
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
