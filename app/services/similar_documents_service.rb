class RelevantDocumentService
  attr_reader :data_source

  def initialize(data_source)
    @data_source = data_source
  end

  def similar(document)
    @data_source.where.not(signature: document.signature).map do |compared|
      DocumentComparaison.new(document, compared)
    end.sort_by(&:resemblance)
  end
end
