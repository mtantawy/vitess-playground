# frozen_string_literal: true

class CustomersController < ApplicationController
  def create
    render(json: CreateCustomerJob.perform_now)
  end

  def update
    render(json: UpdateRandomCustomerJob.perform_now)
  end

  def find
    render(json: FindRandomCustomerJob.perform_now)
  end

  def delete
    # to be implemented when soft-delete is added
  end
end
