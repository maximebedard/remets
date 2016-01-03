class Match < ActiveRecord::Base
  has_many :document_matches, inverse_of: :match
  validates :fingerprints, presence: true
end
