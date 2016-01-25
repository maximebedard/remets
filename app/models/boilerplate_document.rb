class BoilerplateDocument < ActiveRecord::Base
  include Fingerprintable

  belongs_to :handover
end
