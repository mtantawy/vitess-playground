# frozen_string_literal: true

class FindRandomProductJob < ApplicationJob
  queue_as :default

  def perform(*args)
    product_max_id = Product.maximum(:id)
    product_min_id = Product.minimum(:id)

    Product.find_by(
      id: rand(product_min_id..product_max_id),
    )
  end
end
