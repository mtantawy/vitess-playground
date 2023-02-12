# frozen_string_literal: true

class CustomerAddress < ApplicationRecord
  include CustomerAddressAttributeValuesGenerator

  enum :kind, shipping: "shipping", billing: "billing"

  belongs_to :customer, inverse_of: :addresses
  has_many :orders_as_billing_address,
    class_name: "Order",
    dependent: :destroy,
    foreign_key: :billing_address_id,
    inverse_of: :billing_address
  has_many :orders_as_shipping_address,
    class_name: "Order",
    dependent: :destroy,
    foreign_key: :shipping_address_id,
    inverse_of: :shipping_address

  class << self
    def create
      address = new(
        kind: kinds.values.sample,
        default: [true, false].sample,
        street: generate_street,
        postcode: generate_postcode,
        city: generate_city,
        country: generate_country,
        customer: FindRandomCustomerJob.perform_now,
      )

      address.save!

      address
    end

    def update(address)
      address.update(
        kind: kinds.values.sample,
        default: [true, false].sample,
        street: generate_street,
        postcode: generate_postcode,
        city: generate_city,
        country: generate_country,
      )

      address.save!

      address
    end
  end
end
