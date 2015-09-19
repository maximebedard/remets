class Winnowing
  def initialize(window_size: 4, kgrams_size: 5)
    @window_size = window_size
    @kgrams_size = kgrams_size
  end

  def call(content)
    sanitized_tokens = sanitize(tokenize(content))

    fingerprints =
      kgrams(sanitized_tokens, k: @kgrams_size) do |kgram|
        fingerprint(kgram)
      end

    windows =
      kgrams(fingerprints, k: @window_size) do |kgram|
        kgram.min_by { |window| window[1] }
      end

    Set.new(windows).to_a
  end

  def tokenize(value)
    0.upto(value.size-1).to_a.zip(value.chars)
  end

  def sanitize(tokens)
    tokens.map { |token| [token[0], token[1].downcase] }
          .select { |token| token[1] =~ /\w/ }
  end

  def kgrams(tokens, k: 5)
    n = tokens.size
    ret = []
    if n < k
      ret << (yield tokens)
    else
      0.upto(n - k + 1) do |i|
        ret << (yield tokens[i,(i+k)])
      end
    end
    ret
  end

  def fingerprint(tokens)
    indexes, text = tokens.transpose

    fingerprint = hash_func(text.join)

    [indexes.first, fingerprint]
  end

  def hash_func(value)
    Digest::MD5.hexdigest(value).last(4).to_i(16)
  end
end
