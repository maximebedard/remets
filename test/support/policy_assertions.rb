module Remets
  module PolicyAssertions
    def assert_permit(current_user, record, action, *args)
      assert permit(current_user, record, action), *args
    end

    def refute_permit(current_user, record, action, *args)
      refute permit(current_user, record, action), *args
    end

    def assert_permit_raises(current_user, record, action, *args)
      assert_raises(*args) { permit(current_user, record, action) }
    end

    def permit(current_user, record, action)
      self.class.to_s.gsub(/Test/, "")
        .constantize.new(current_user, record)
        .public_send("#{action}?")
    end
  end
end
