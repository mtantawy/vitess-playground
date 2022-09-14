# frozen_string_literal: true

class CreateProductJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Product.create
  end
end
