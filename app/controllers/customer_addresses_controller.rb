# frozen_string_literal: true

class CustomerAddressesController < ApplicationController
  def create
    render(json: CreateCustomerAddressJob.perform_now)
  end

  def update
    render(json: UpdateRandomCustomerAddressJob.perform_now)
  end

  def find
    render(json: FindRandomCustomerAddressJob.perform_now)
  end

  def delete
    # to be implemented when soft-delete is added
  end
end
