# frozen_string_literal: true

require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "Product.create creates a Product with attributes set" do
    product = Product.create
    assert_predicate product, :persisted?
    assert_not_predicate product.name, :empty?
    assert_not_predicate product.description, :empty?
    assert_operator product.quantity, :<, 1000
    assert_operator product.quantity, :>=, 0
  end

  test "Product.create retries on ActiveRecord::RecordNotUnique Error" do
    # mock Faker::Commerce.product_name
    # create product with a known name to be used later
    # make it return same name twice, then different name on 3rd try
    # assert product was persisted with the unique 3rd name
    # assert no error was raised
  end
end
