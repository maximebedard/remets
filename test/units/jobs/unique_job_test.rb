# require "test_helper"
#
# class DummyUniqueJob < ActiveJob::Base
#   include UniqueJob
#
#   queue_as :default
#
#   def perform(user)
#   end
# end
#
# class Remets::UniqueJobTest < ActiveSupport::TestCase
#   test "the lock key contains the job type" do
#     user = users(:henry)
#     job_a = DummyUniqueJob.new(user)
#     job_b = DummyUniqueJob.new(user)
#
#     called = false
#     job_a.acquire_lock do
#       job_b.acquire_lock do
#         called = true
#       end
#     end
#     assert called
#   end
#
#   test "the lock key is serialized" do
#     user = users(:henry)
#     job = DummyUniqueJob.new(user)
#     key = %(DummyUniqueJob-{"_aj_globalid"=>"gid://remets/User/#{user.id}"})
#     assert_equal key, job.lock_key(*job.arguments)
#   end
# end
