# frozen_string_literal: true

class Customer < ApplicationRecord
  include CustomerAttributeValuesGenerator

  has_many :addresses, class_name: "CustomerAddress", dependent: :destroy
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
end
