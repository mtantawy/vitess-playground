# frozen_string_literal: true

class FindRandomJob; end

ApplicationJob::MODELS.each do |model|
  Object.const_set("FindRandom#{model}Job", Class.new(ApplicationJob) do
    queue_as :default

    define_method :perform do |*_args|
      max_id = model.maximum(:id)
      min_id = model.minimum(:id)

      find_random_record(min_id: min_id, max_id: max_id)
    end

    define_method :find_random_record do |min_id:, max_id:|
      # TODO: push a metric here to track retries
      record = model.find_by(id: rand(min_id..max_id)) until record.is_a?(model)
      record
    end

    private :find_random_record
  end)
end
