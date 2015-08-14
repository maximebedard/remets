class SubmissionsController < ApplicationController
  def index
  end

  def new
  end

  def create
    @service = SubmissionService.new(document_params)
    respond_with @service.document
  end

  private

  def document_params
    params.require(:document).permit(:content)
  end
end
