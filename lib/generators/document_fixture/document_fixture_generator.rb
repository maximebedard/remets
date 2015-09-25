class DocumentFixtureGenerator < Rails::Generators::Base
  argument :url, type: :string

  def generate_document_file
    id = Dir.entries('test/fixtures/files/documents/file').last.to_i + 1

    doc = Nokogiri::HTML(open(url))
    title = doc.css('#firstHeading').text
    body = doc.css('#mw-content-text').text

    destination = "test/fixtures/files/documents/file/#{id}/#{title.parameterize}.txt"
    create_file(destination, body)
    append_file "test/fixtures/documents.yml",
<<YAML
#{title.underscore.gsub(/\s/, '_')}: # #{id}
  submission: ~
  file: '#{title.parameterize}.txt'
YAML
  end
end
