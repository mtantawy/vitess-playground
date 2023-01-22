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

      begin
        product.save!
      rescue ActiveRecord::RecordNotUnique
        # TODO: push a metric here to track retries
        product.sku = generate_sku
        retry
      end

      product
    end
  end
end
