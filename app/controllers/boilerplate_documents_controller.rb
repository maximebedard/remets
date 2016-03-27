class BoilerplateDocumentsController < ApplicationController
  include Downloadable
  self.downloadable_class = BoilerplateDocument
  must_be_authenticated
end
