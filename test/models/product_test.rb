# frozen_string_literal: true

require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "Product.create creates a Product with attributes set" do
    product = Product.create
    assert_predicate product, :persisted?
    assert_not_predicate product.sku, :empty?
    assert_not_predicate product.name, :empty?
    assert_not_predicate product.description, :empty?
    assert_operator product.quantity, :<, 1000
    assert_operator product.quantity, :>=, 0
  end

  test "Product.create retries on ActiveRecord::RecordNotUnique Error" do
    # mock Product.create_product_sku which uses Faker::Alphanumeric.alphanumeric
    # make it return same sku twice, then different sku on 3rd try
    Product.stubs(:create_product_sku).returns("SteamDeck", "SteamDeck", "SteamDeck2")

    # create product with the same sku mocked earlier
    product1 = Product.create!(sku: "SteamDeck")
    assert_predicate product1, :persisted?
    assert_equal "SteamDeck", product1.sku

    product2 = Product.create
    assert_predicate product2, :persisted?
    # assert product was persisted with the unique 3rd sku
    assert_equal "SteamDeck2", product2.sku
  end
end
