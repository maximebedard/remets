class RelevantDocumentService

  class SameDocumentError < StandardError
  end

  attr_reader :data_source

  def initialize(data_source)
    @data_source = data_source
  end

  def search_relevants(document)
    @data_source.where.not(signature: document.signature).map do |compared|
      {
        source: document,
        compared: compared,
        resemblance: self.class.resemblance(document, compared)
      }
    end.sort_by(&:resemblance)
  end

  def self.compare(document1, document2)
    raise SameDocumentError if document1 == document2

    resemblance(document1, document2)
  end

  private

  def self.resemblance(document1, document2)
    num = document1.shingles & document2.shingles
    denum = document1.shingles | document2.shingles
    num.size.to_f / denum.size
  end
end
