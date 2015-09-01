class DocumentComparaison

  class SameDocumentError < StandardError
  end

  attr_reader :document1,
              :document2

  def initialize(document1, document2)
    raise SameDocumentError if document1 == document2
    raise ArgumentError if document1.nil? || document2.nil?

    @document1 = document1
    @document2 = document2
  end

  def resemblance
    @ressemblance ||= evaluate_resemblance
  end

  private

  def evaluate_resemblance
    num = @document1.shingles & @document2.shingles
    denum = @document1.shingles | @document2.shingles
    num.size.to_f / denum.size
  end
end
