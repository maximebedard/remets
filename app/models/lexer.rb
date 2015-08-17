class Lexer
  REGEX = /[\w\']+(?:\:\/\/[\w\.\/]+){0,1}/

  def tokenize(value)
    value.scan(REGEX)
  end
end
