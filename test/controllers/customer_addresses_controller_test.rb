# frozen_string_literal: true

require "test_helper"

class CustomerAddressesControllerTest < ActionDispatch::IntegrationTest
  test "post to customer_addresses create succeeds and returns created customer address" do
    assert_difference "CustomerAddress.count" do
      post customer_addresses_create_url
    end
    assert_response :success
    assert_address_returned
  end

  test "get to customer_addresses find returns a customer address" do
    assert_no_difference "Customer.count" do
      get customer_addresses_find_url
    end
    assert_response :success
    assert_address_returned
  end

  test "post to customer_addresses update succeeds and returns updated customer address" do
    # first remove all customer_addresses
    CustomerAddress.destroy_all
    # then create one customer address to then assert it got updated
    address = CustomerAddress.create
    assert_changes -> { address.reload.updated_at } do
      post customer_addresses_update_url
    end
    assert_response :success
    assert_address_returned
  end

  private

  def assert_address_returned
    assert_kind_of(Hash, @response.parsed_body)
    assert_equal(true, @response.parsed_body.key?("id"), "Response missing `id`")
    assert_equal(true, @response.parsed_body.key?("kind"), "Response missing `kind`")
    assert_equal(true, @response.parsed_body.key?("default"), "Response missing `default`")
    assert_equal(true, @response.parsed_body.key?("street"), "Response missing `street`")
    assert_equal(true, @response.parsed_body.key?("postcode"), "Response missing `postcode`")
    assert_equal(true, @response.parsed_body.key?("city"), "Response missing `city`")
    assert_equal(true, @response.parsed_body.key?("country"), "Response missing `country`")
    assert_equal(true, @response.parsed_body.key?("customer_id"), "Response missing `customer_id`")
  end
end
