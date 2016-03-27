class ReferenceDocumentsController < ApplicationController
  include Downloadable
  must_be_authenticated
end
