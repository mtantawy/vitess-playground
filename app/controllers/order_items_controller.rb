# frozen_string_literal: true

class OrderItemsController < ApplicationController
  def create
    render(json: CreateOrderItemJob.perform_now)
  end

  def update
    render(json: UpdateRandomOrderItemJob.perform_now)
  end

  def find
    render(json: FindRandomOrderItemJob.perform_now)
  end

  def delete
    # to be implemented when soft-delete is added
  end
end
