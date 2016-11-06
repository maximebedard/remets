class BoilerplateDocument < ApplicationRecord
  include HasFile
  include HasSanitizedFile

  belongs_to :evaluation
end
