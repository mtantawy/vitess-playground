# frozen_string_literal: true

class Order < ApplicationRecord
  enum :status, pending: "pending", completed: "completed", cancelled: "cancelled"
  enum :payment_method, credit_card: "credit_card", paypal: "paypal", bank_transfer: "bank_transfer"

  belongs_to :customer
  belongs_to :shipping_address, class_name: "CustomerAddress"
  belongs_to :billing_address, class_name: "CustomerAddress"
  has_many :items, class_name: "OrderItem", dependent: :destroy
  has_many :products, through: :items

  class << self
    def create
      customer = FindRandomCustomerJob.perform_now
      order = new(
        paid: [true, false].sample,
        customer: customer,
        total_amount: (rand * 1000).round(2),
        status: statuses.values.sample,
        shipping_address: customer.shipping_address,
        billing_address: customer.billing_address,
        payment_method: payment_methods.values.sample,
      )

      order.save!

      order
    end

    def update(order)
      customer = FindRandomCustomerJob.perform_now
      order.update(
        paid: [true, false].sample,
        customer: customer,
        total_amount: (rand * 1000).round(2),
        status: statuses.values.sample,
        shipping_address: customer.shipping_address,
        billing_address: customer.billing_address,
        payment_method: payment_methods.values.sample,
      )

      order.save!

      order
    end
  end
end
