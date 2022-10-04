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
    # mock Product.create_product_name which uses Faker::Commerce.product_name
    # make it return same name twice, then different name on 3rd try
    Product.stubs(:create_product_name).returns("Steam Deck", "Steam Deck", "Steam Deck 2")

    # create product with the same name mocked earlier
    product1 = Product.create!(name: "Steam Deck")
    assert_predicate product1, :persisted?
    assert_equal "Steam Deck", product1.name

    product2 = Product.create
    assert_predicate product2, :persisted?
    # assert product was persisted with the unique 3rd name
    assert_equal "Steam Deck 2", product2.name
  end
end
