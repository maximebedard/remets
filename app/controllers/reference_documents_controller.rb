class ReferenceDocumentsController < ApplicationController
  include Downloadable
  self.downloadable_class = ReferenceDocument
  must_be_authenticated
end
