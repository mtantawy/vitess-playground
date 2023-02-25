# frozen_string_literal: true

require "test_helper"

class UpdateRandomProductJobTest < ActiveJob::TestCase
  test "UpdateRandomProductJob updates attributes" do
    Product.expects(:generate_name).returns("Updated Name").once
    Product.expects(:generate_description).returns("I am an updated description").once
    Product.expects(:generate_quantity).returns(100).once

    updated_product = UpdateRandomProductJob.perform_now
    assert_predicate updated_product, :persisted?
    assert_equal "Updated Name", updated_product.name
    assert_equal "I am an updated description", updated_product.description
    assert_equal 100, updated_product.quantity
  end
end
