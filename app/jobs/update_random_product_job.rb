# frozen_string_literal: true

class UpdateRandomProductJob < ApplicationJob
  queue_as :default

  def perform(*args)
    product = find_random_product
    product.name = Product.generate_name
    product.description = Product.generate_description
    product.quantity = Product.generate_quantity

    product.save!
    product
  end

  private

  def find_random_product
    # TODO: push a metric here to track retries
    product = FindRandomProductJob.perform_now until product.is_a?(Product)
    product
  end
end
