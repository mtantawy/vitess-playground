# frozen_string_literal: true

class Customer < ApplicationRecord
  include CustomerAttributeValuesGenerator

  has_many :addresses, class_name: "CustomerAddress", dependent: :destroy
  has_many :orders, dependent: :destroy

  class << self
    def create
      customer = new(
        name: generate_name,
        email: generate_email,
      )

      customer.retryable_save

      customer
    end

    def update(customer)
      customer.update(
        name: generate_name,
        email: generate_email,
      )

      customer.retryable_save

      customer
    end
  end

  def retryable_save
    save!
  rescue ActiveRecord::RecordNotUnique
    # TODO: push a metric here to track retries
    self.email = Customer.generate_email
    retry
  end

  def shipping_address
    addresses.where(kind: :shipping).sample || create_address_for_customer_with_kind(:shipping)
  end

  def billing_address
    addresses.where(kind: :billing).sample || create_address_for_customer_with_kind(:billing)
  end

  private

  def create_address_for_customer_with_kind(kind)
    address = CreateCustomerAddressJob.perform_now
    address.update!(customer: self, kind: kind)
    address
  end
end
