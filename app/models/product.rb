# frozen_string_literal: true

class Product < ApplicationRecord
  include ProductAttributeValuesGenerator
  class << self
    def create
      product = new(
        sku: generate_sku,
        name: generate_name,
        description: generate_description,
        quantity: generate_quantity,
      )

      product.retryable_save

      product
    end

    def update(product)
      product.name = generate_name
      product.description = generate_description
      product.quantity = generate_quantity

      product.retryable_save

      product
    end
  end

  def retryable_save
    save!
  rescue ActiveRecord::RecordNotUnique
    # TODO: push a metric here to track retries
    self.sku = Product.generate_sku
    retry
  end
end
