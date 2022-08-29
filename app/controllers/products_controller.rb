# frozen_string_literal: true

class ProductsController < ApplicationController
  def create
    render(json: Product.create)
  end

  def update
  end

  def delete
  end
end
