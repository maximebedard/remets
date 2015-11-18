class Winnower
  class << self
    def windows_from_content(content, *options)
      new(options).perform(ContentTokenizer.sanitize_and_tokenize(content))
    end

    def windows_from_tokens(tokens, *options)
      new(options).perform(tokens)
    end
  end

  private

  def initialize(window_size: 4, kgrams_size: 5)
    @window_size = window_size
    @kgrams_size = kgrams_size
  end

  def perform(tokens)
    fingerprints =
      kgrams(tokens, k: @kgrams_size) do |kgram|
        fingerprint(kgram)
      end

    windows =
      kgrams(fingerprints, k: @window_size) do |kgram|
        kgram.min_by { |window| window[1] }
      end

    windows
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
