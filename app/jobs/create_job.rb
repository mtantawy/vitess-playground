# frozen_string_literal: true

class CreateJob; end

[Product, Customer].each do |model|
  Object.const_set("Create#{model}Job", Class.new(ApplicationJob) do
    queue_as :default

    define_method :perform do |*_args|
      model.create
    end
  end)
end
