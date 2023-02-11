# frozen_string_literal: true

class UpdateRandomJob; end

[Product, Customer].each do |model|
  Object.const_set("UpdateRandom#{model}Job", Class.new(ApplicationJob) do
    queue_as :default

    define_method :perform do |*_args|
      record = find_random_record
      model.update(record)
    end

    define_method :find_random_record do
      # TODO: push a metric here to track retries
      record = "FindRandom#{model}Job".constantize.perform_now until record.is_a?(model)
      record
    end

    private :find_random_record
  end)
end
