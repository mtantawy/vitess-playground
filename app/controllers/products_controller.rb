# frozen_string_literal: true

class ProductsController < ApplicationController
  def create
    render(json: CreateProductJob.perform_now)
  end

  def update
    render(json: UpdateRandomProductJob.perform_now)
  end

  def find
    render(json: FindRandomProductJob.perform_now)
  end

  def delete
  end
end
