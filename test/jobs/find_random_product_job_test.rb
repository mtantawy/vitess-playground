# frozen_string_literal: true

require "test_helper"

class FindRandomProductJobTest < ActiveJob::TestCase
  test "FindRandomProductJob returns a Product" do
    random_product = FindRandomProductJob.perform_now
    assert random_product.is_a?(Product)
  end

  test "FindRandomProductJob returns a nil when product with random id is not found" do
    Product.stubs(:minimum).returns(100)
    Product.stubs(:maximum).returns(101)

    random_product = FindRandomProductJob.perform_now
    assert_predicate random_product, :nil?
  end
end
