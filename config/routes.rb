# frozen_string_literal: true

Rails.application.routes.draw do
  [:products, :customers].each do |model|
    post "#{model}/create"
    post "#{model}/update"
    get "#{model}/find"
    post "#{model}/delete"
  end
end
