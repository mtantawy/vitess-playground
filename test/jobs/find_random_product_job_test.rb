# frozen_string_literal: true

require "test_helper"

class FindRandomProductJobTest < ActiveJob::TestCase
  test "FindRandomProductJob returns a Product" do
    random_product = FindRandomProductJob.perform_now
    assert random_product.is_a?(Product)
  end

  test "FindRandomProductJob returns a nil when product with random id is not found" do
    Product.stubs(:find_by).returns(nil, products(:one)).twice

    random_product = FindRandomProductJob.perform_now
    assert random_product.is_a?(Product)
  end
end
