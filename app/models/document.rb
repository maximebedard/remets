class Document < ActiveRecord::Base
  include Fingerprintable

  belongs_to :submission
end
