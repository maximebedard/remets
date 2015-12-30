module Remets
  module SessionHelper
    def sign_in(user)
      @controller.current_user = user
      return unless block_given?

      begin
        yield
      ensure
        sign_out
      end
    end

    def sign_out
      @controller.current_user = nil
    end
  end
end
