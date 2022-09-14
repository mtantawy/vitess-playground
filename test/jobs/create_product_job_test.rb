# frozen_string_literal: true

require "test_helper"

class CreateProductJobTest < ActiveJob::TestCase
  test "A product is created and is persisted" do
    product = CreateProductJob.perform_now
    assert_predicate product, :persisted?
  end
end
