# frozen_string_literal: true

class CustomerAddress < ApplicationRecord
  include CustomerAddressAttributeValuesGenerator

  belongs_to :customer, inverse_of: :addresses
  enum :kind, shipping: "shipping", billing: "billing"

  class << self
    def create
      address = new(
        kind: [:shipping, :billing].sample,
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
        kind: [:shipping, :billing].sample,
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
