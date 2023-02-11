# frozen_string_literal: true

require "test_helper"

class CustomersControllerTest < ActionDispatch::IntegrationTest
  test "post to customers create succeeds and returns created customer" do
    assert_difference "Customer.count" do
      post customers_create_url
    end
    assert_response :success
    assert_customer_returned
  end

  test "get to customers find returns a customer" do
    assert_no_difference "Customer.count" do
      get customers_find_url
    end
    assert_response :success
    assert_customer_returned
  end

  test "post to customers update succeeds and returns updated customer" do
    # first remove all customers
    Customer.destroy_all
    # then create one customer to then assert it got updated
    customer = Customer.create
    assert_changes -> { customer.reload.updated_at } do
      post customers_update_url
    end
    assert_response :success
    assert_customer_returned
  end

  private

  def assert_customer_returned
    assert_kind_of(Hash, @response.parsed_body)
    assert_equal(true, @response.parsed_body.key?("id"), "Response missing `id`")
    assert_equal(true, @response.parsed_body.key?("name"), "Response missing `name`")
    assert_equal(true, @response.parsed_body.key?("email"), "Response missing `email`")
  end
end
