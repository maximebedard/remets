class DownloadController < ApplicationController
  must_be_authenticated

  def show
    send_file(
      file.url,
      disposition: :inline,
    )
  end

  private

  def file
    RemoteFile.new(params[:key])
  end
end
