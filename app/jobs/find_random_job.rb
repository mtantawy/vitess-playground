# frozen_string_literal: true

class FindRandomJob; end

ApplicationJob::MODELS.each do |model|
  Object.const_set("FindRandom#{model}Job", Class.new(ApplicationJob) do
    queue_as :default

    define_method :perform do |*_args|
      max_id = model.maximum(:id)
      min_id = model.minimum(:id)

      model.find_by(
        id: rand(min_id..max_id),
      )
    end
  end)
end
