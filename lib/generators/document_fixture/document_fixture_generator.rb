class DocumentFixtureGenerator < Rails::Generators::Base
  argument :url, type: :string

  def generate_document_file
    destination = "test/fixtures/files/documents/file/#{document[:id]}/#{document[:title].parameterize}.txt"
    create_file(destination, document[:body])
  end

  def generate_fixture
    append_file "test/fixtures/documents.yml", document_yaml
  end

  private

  def document
    @document ||= fetch_document_info
  end

  def document_yaml
<<YAML

#{document[:title].downcase.gsub(/\W/, '_')}: # #{document[:id]}
  submission: ~
  file: '#{document[:title].parameterize}.txt'
YAML
  end

  def fetch_document_info
    doc = Nokogiri::HTML(open(url))

    {
      id: Dir.entries('test/fixtures/files/documents/file').last.to_i + 1,
      title: doc.css('#firstHeading').text,
      content: doc.css('#mw-content-text').text
    }
  end
end
