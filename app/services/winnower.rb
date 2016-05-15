class Winnower
  class << self
    def windows_from_content(content, **options)
      content ||= ""

      new(options).perform(ContentTokenizer.tokenize(content))
    end

    def windows_from_tokens(tokens, **options)
      tokens ||= []

      new(options).perform(tokens)
    end
  end

  def perform(tokens)
    return Set.new unless tokens.present?

    fingerprints = build_fingerprints(tokens)
    windows = build_windows(fingerprints)

    Set.new(windows)
  end

  private

  def initialize(window_size: 4, kgrams_size: 5)
    @window_size = window_size
    @kgrams_size = kgrams_size
  end

  def build_fingerprints(tokens)
    each_cons(tokens, @kgrams_size).map do |kgram|
      fingerprint(kgram)
    end
  end

  def build_windows(fingerprints)
    each_cons(fingerprints, @window_size).map do |kgram|
      kgram.min { |a, b| a[1] <=> b[1] }
    end
  end

  def fingerprint(indexed_tokens)
    indexes, tokens = indexed_tokens.transpose

    fingerprint = hash(tokens.join)

    [indexes.first, fingerprint]
  end

  def each_cons(enumerable, n)
    return [enumerable] if enumerable.size < n
    enumerable.each_cons(n)
  end

  def hash(value)
    Digest::SHA1.hexdigest(value).last(4).to_i(16)
  end
end
