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
  #  # reference_id | compared_id | match_id
  #  # -------------+-------------+----------
  #  #            1 |           2 |        1
  #  #            2 |           1 |        1
  #
  #  # Upload document 3 => 6 matches
  #  perform(3) # => nil
  #  # reference_id | compared_id | match_id
  #  # -------------+-------------+----------
  #  #            1 |           2 |        1
  #  #            2 |           1 |        1
  #  #            3 |           1 |        2
  #  #            3 |           2 |        2
  #  #            1 |           3 |        2
  #  #            2 |           3 |        2
  def perform(document_id)
    reference = Document.find(document_id)

    Document.all_fingerprinted_except(reference).find_each do |compared|
      DocumentMatch.create_from!(reference, compared)
    end
  end
end
