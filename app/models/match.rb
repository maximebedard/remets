class Match < ActiveRecord::Base
  has_many :document_matches

  validates :fingerprints, presence: true
end
