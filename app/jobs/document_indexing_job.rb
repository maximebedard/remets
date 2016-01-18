class DocumentIndexingJob < ActiveJob::Base
  queue_as :default

  # Public: Creates document matches for all the documents previously stored. Only fingerprinted documents
  # are considered.
  #
  # document_id - The id of the document to append to the index
  #
  # Examples
  #
  #  # Upload document 1 => No match
  #  perform(1) # => nil
  #
  #  # Upload document 2 => 2 matches
  #  perform(2) # => nil
  #  # reference_id | compared_id | fingerprints | similarity
  #  # -------------+-------------+--------------+-----------
  #  #            1 |           2 |          [a] |         s
  #  #            2 |           1 |          [a] |         s
  #
  #  # Upload document 3 => 6 matches
  #  perform(3) # => nil
  #  # reference_id | compared_id | fingerprints | similarity
  #  # -------------+-------------+--------------+-----------
  #  #            1 |           2 |          [a] |         s
  #  #            2 |           1 |          [a] |         s
  #  #            3 |           1 |          [b] |         s
  #  #            3 |           2 |          [c] |         s
  #  #            1 |           3 |          [b] |         s
  #  #            2 |           3 |          [c] |         s
  #
  # Notes: This is pretty bad because it's in O((n-1)!). A way to improve it would be to add matches using and
  # querying using the following query: SELECT * FROM document_matches where reference_document_id = ?
  # OR compared_document_id = ? ORDER BY array_length(fingerprints, 1) DESC
  def perform(document_id)
    reference = Document.find(document_id)

    Document.all_fingerprinted_except(reference).find_each do |compared|
      DocumentMatch.create_from!(reference, compared)
    end
  end
end
