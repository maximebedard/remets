module MustBeAuthenticated
  extend ActiveSupport::Concern

  def initialize(*)
    super
    authenticate!
  end
end
