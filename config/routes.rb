# frozen_string_literal: true

Rails.application.routes.draw do
  post "products/create"
  post "products/update"
  post "products/delete"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
