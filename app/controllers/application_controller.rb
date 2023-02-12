# frozen_string_literal: true

class ApplicationController < ActionController::API
end

[Product, Customer, CustomerAddress, Order, OrderItem].each do |model|
  Object.const_set("#{model.model_name.plural.camelize}Controller", Class.new(ApplicationController) do
    define_method :create do
      render(json: "Create#{model.model_name.name}Job".constantize.perform_now)
    end

    define_method :update do
      render(json: "UpdateRandom#{model.model_name.name}Job".constantize.perform_now)
    end

    define_method :find do
      render(json: "FindRandom#{model.model_name.name}Job".constantize.perform_now)
    end

    define_method :delete do
      # to be implemented when soft-delete is added
    end
  end)
end
