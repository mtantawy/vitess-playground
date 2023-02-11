# frozen_string_literal: true

module CustomerAttributeValuesGenerator
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
    def generate_name
      Faker::Name.name
    end

    def generate_email
      Faker::Internet.safe_email
    end
  end
end
