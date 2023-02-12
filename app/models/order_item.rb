# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order, inverse_of: :items
  belongs_to :product

  class << self
    def create
      order_item = new(
        quantity: rand(0..10),
        price: (rand * 100).round(2),
        order: FindRandomOrderJob.perform_now,
        product: FindRandomProductJob.perform_now,
      )

      order_item.save!

      order_item
    end

    def update(order_item)
      order_item.update(
        quantity: rand(0..10),
        price: (rand * 100).round(2),
        order: FindRandomOrderJob.perform_now,
        product: FindRandomProductJob.perform_now,
      )

      order_item.save!

      order_item
    end
  end
end
