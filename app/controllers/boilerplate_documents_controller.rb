class BoilerplateDocumentsController < ApplicationController
  include Downloadable
  must_be_authenticated
end
