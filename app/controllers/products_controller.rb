# frozen_string_literal: true

class ProductsController < ApplicationController
  def create
    render(json: CreateProductJob.perform_now)
  end

  def update
  end

  def delete
  end
end
