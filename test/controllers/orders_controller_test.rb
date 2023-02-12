# frozen_string_literal: true

require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "post to orders create succeeds and returns created order" do
    assert_difference "Order.count" do
      post orders_create_url
    end
    assert_response :success
    assert_order_returned
  end

  test "get to orders find returns a order" do
    assert_no_difference "Order.count" do
      get orders_find_url
    end
    assert_response :success
    assert_order_returned
  end

  test "post to orders update succeeds and returns updated order" do
    # first remove all orders
    Order.destroy_all
    # then create one order to then assert it got updated
    order = Order.create
    assert_changes -> { order.reload.updated_at } do
      post orders_update_url
    end
    assert_response :success
    assert_order_returned
  end

  private

  def assert_order_returned
    assert_kind_of(Hash, @response.parsed_body)
    assert_equal(true, @response.parsed_body.key?("id"), "Response missing `id`")
    assert_equal(true, @response.parsed_body.key?("paid"), "Response missing `paid`")
    assert_equal(true, @response.parsed_body.key?("customer_id"), "Response missing `customer_id`")
    assert_equal(true, @response.parsed_body.key?("total_amount"), "Response missing `total_amount`")
    assert_equal(true, @response.parsed_body.key?("status"), "Response missing `status`")
    assert_equal(true, @response.parsed_body.key?("shipping_address_id"), "Response missing `shipping_address_id`")
    assert_equal(true, @response.parsed_body.key?("billing_address_id"), "Response missing `billing_address_id`")
    assert_equal(true, @response.parsed_body.key?("payment_method"), "Response missing `payment_method`")
  end
end
