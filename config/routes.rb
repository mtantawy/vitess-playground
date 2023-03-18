# frozen_string_literal: true

Rails.application.routes.draw do
  [:products, :customers, :customer_addresses, :orders, :order_items].each do |model|
    post "#{model}/create"
    post "#{model}/update"
    get "#{model}/find"
    post "#{model}/delete"
  end

  post "noop", to: "no_op#run"
end
