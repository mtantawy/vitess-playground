# frozen_string_literal: true

module CustomerAddressAttributeValuesGenerator
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
    def generate_street
      Faker::Address.street_address
    end

    def generate_postcode
      Faker::Address.postcode
    end

    def generate_city
      Faker::Address.city
    end

    def generate_country
      Faker::Address.country
    end
  end
end
