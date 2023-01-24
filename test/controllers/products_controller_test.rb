# frozen_string_literal: true

require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "post to products create succeeds and returns created product" do
    assert_difference "Product.count" do
      post products_create_url
    end
    assert_response :success
    assert_product_returned
  end

  test "get to products find returns a product" do
    assert_no_difference "Product.count" do
      get products_find_url
    end
    assert_response :success
    assert_product_returned
  end

  test "post to products update succeeds and returns updated product" do
    # first remove all products
    Product.destroy_all
    # then create one product to then assert it got updated
    product = Product.create
    assert_changes -> { product.reload.updated_at } do
      post products_update_url
    end
    assert_response :success
    assert_product_returned
  end

  private

  def assert_product_returned
    assert_kind_of(Hash, @response.parsed_body)
    assert_equal(true, @response.parsed_body.key?("id"), "Response missing `id`")
    assert_equal(true, @response.parsed_body.key?("name"), "Response missing `name`")
    assert_equal(true, @response.parsed_body.key?("description"), "Response missing `description`")
    assert_equal(true, @response.parsed_body.key?("quantity"), "Response missing `quantity`")
  end
end
