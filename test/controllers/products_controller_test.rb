# frozen_string_literal: true

require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "post to products create succeeds and returns created product" do
    post products_create_url
    assert_response :success
    assert_kind_of Hash, @response.parsed_body
    assert_equal true, @response.parsed_body.key?("id"), "Response missing `id`"
    assert_equal true, @response.parsed_body.key?("name"), "Response missing `name`"
    assert_equal true, @response.parsed_body.key?("description"), "Response missing `description`"
    assert_equal true, @response.parsed_body.key?("quantity"), "Response missing `quantity`"
  end

  # test "should get update" do
  #   get products_update_url
  #   assert_response :success
  # end

  # test "should get delete" do
  #   get products_delete_url
  #   assert_response :success
  # end
end
