# frozen_string_literal: true

require "test_helper"

class OrderItemsControllerTest < ActionDispatch::IntegrationTest
  test "post to order_items create succeeds and returns created order_item" do
    assert_difference "OrderItem.count" do
      post order_items_create_url
    end
    assert_response :success
    assert_order_item_returned
  end

  test "get to order_items find returns a order_item" do
    assert_no_difference "OrderItem.count" do
      get order_items_find_url
    end
    assert_response :success
    assert_order_item_returned
  end

  test "post to order_items update succeeds and returns updated order_item" do
    # first remove all order_items
    OrderItem.destroy_all
    # then create one order_item to then assert it got updated
    order_item = OrderItem.create
    assert_changes -> { order_item.reload.updated_at } do
      post order_items_update_url
    end
    assert_response :success
    assert_order_item_returned
  end

  private

  def assert_order_item_returned
    assert_kind_of(Hash, @response.parsed_body)
    assert_equal(true, @response.parsed_body.key?("id"), "Response missing `id`")
    assert_equal(true, @response.parsed_body.key?("quantity"), "Response missing `quantity`")
    assert_equal(true, @response.parsed_body.key?("price"), "Response missing `price`")
    assert_equal(true, @response.parsed_body.key?("order_id"), "Response missing `order_id`")
    assert_equal(true, @response.parsed_body.key?("product_id"), "Response missing `product_id`")
  end
end
