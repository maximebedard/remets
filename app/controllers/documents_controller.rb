class DocumentsController < ApplicationController
  include Downloadable
  self.downloadable_class = Document
  must_be_authenticated
end
