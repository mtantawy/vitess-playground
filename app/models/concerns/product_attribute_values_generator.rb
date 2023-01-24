# frozen_string_literal: true

module ProductAttributeValuesGenerator
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
    def generate_name
      "#{Faker::Commerce.product_name} #{rand(1000)}"
    end

    def generate_sku
      Faker::Alphanumeric.alphanumeric(number: 16).upcase
    end

    def generate_description
      Faker::Lorem.sentence(random_words_to_add: 5)
    end

    def generate_quantity
      rand(1000)
    end
  end
end
