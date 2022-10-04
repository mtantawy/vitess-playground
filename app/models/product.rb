# frozen_string_literal: true

class Product < ApplicationRecord
  class << self
    def create
      product = new(
        name: create_product_name,
        description: Faker::Lorem.sentence(random_words_to_add: 5),
        quantity: rand(1000),
      )

      begin
        product.save!
      rescue ActiveRecord::RecordNotUnique
        product.name = create_product_name
        retry
      end

      product
    end

    private

    def create_product_name
      "#{Faker::Commerce.product_name} #{rand(1000)}"
    end
  end
end
