class Signature
  def self.sign(value)
    Digest::MD5.hexdigest(value)
  end
end
