# frozen_string_literal: true

class Product < ApplicationRecord
  class << self
    def create
      product = new(
        name: Faker::Commerce.product_name,
        description: Faker::Lorem.sentence(random_words_to_add: 5),
        quantity: rand(1000)
      )

      begin
        product.save!
      rescue ActiveRecord::RecordNotUnique
        product.name = Faker::Commerce.product_name
        retry
      end

      product
    end
  end
end
