class AcquaintancesController < ApplicationController
  respond_to :json
  must_be_authenticated

  def index
    @aquaintances = Acquaintance.load_from_cache(current_user)
    respond_with(@aquaintances)
  end
end
