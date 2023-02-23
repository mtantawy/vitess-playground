# frozen_string_literal: true

class UpdateRandomJob; end

ApplicationJob::MODELS.each do |model|
  Object.const_set("UpdateRandom#{model}Job", Class.new(ApplicationJob) do
    queue_as :default

    define_method :perform do |*_args|
      model.update("FindRandom#{model}Job".constantize.perform_now)
    end
  end)
end
