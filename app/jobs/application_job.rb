# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  # Listing all models so abstract jobs can iterate over them
  # TODO: find a better place for this
  # Tried to place it in ApplicationRecord but it is not possible because the constants were not initialized yet
  # another solution could be "name".constantize
  MODELS = [Product, Customer, CustomerAddress, Order, OrderItem]
end
