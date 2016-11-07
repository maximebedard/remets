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

    def assert_redirected_to_auth_new(origin: request.url)
      assert_equal origin, session[Remets::ORIGIN_KEY]
      assert_redirected_to auth_new_path
    end
  end
end
