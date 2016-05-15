class BoilerplateDocument < ActiveRecord::Base
  include HasFile
  include HasSanitizedFile

  belongs_to :evaluation
end
