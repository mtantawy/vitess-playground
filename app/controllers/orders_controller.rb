# frozen_string_literal: true

class OrdersController < ApplicationController
  def create
    render(json: CreateOrderJob.perform_now)
  end

  def update
    render(json: UpdateRandomOrderJob.perform_now)
  end

  def find
    render(json: FindRandomOrderJob.perform_now)
  end

  def delete
    # to be implemented when soft-delete is added
  end
end
