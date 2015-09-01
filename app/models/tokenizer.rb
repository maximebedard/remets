class Tokenizer
  WORDS = /[\w\']+(?:\:\/\/[\w\.\/]+){0,1}/

  def tokenize(content)
    content.scan(WORDS)
  end
end
