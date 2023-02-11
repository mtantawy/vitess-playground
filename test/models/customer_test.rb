# frozen_string_literal: true

require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  test "Customer.create creates a Customer with attributes set" do
    customer = Customer.create
    assert_predicate customer, :persisted?
    assert_not_predicate customer.name, :empty?
    assert_not_predicate customer.email, :empty?
  end

  test "Customer.create retries on ActiveRecord::RecordNotUnique Error" do
    # mock Customer.generate_email which uses Faker::Internet.safe_email
    # make it return same email twice, then different email on 3rd try
    Customer.stubs(:generate_email).returns("test@example.com", "test@example.com", "test2@example.com")

    # create customer with the same email mocked earlier
    customer1 = Customer.create!(email: "test@example.com")
    assert_predicate customer1, :persisted?
    assert_equal "test@example.com", customer1.email

    customer2 = Customer.create
    assert_predicate customer2, :persisted?
    # assert customer was persisted with the unique 3rd email
    assert_equal "test2@example.com", customer2.email
  end

  test "Customer.create calls generate_* methods" do
    Customer.expects(:generate_name).once
    Customer.expects(:generate_email).once
    Customer.create
  end
end
