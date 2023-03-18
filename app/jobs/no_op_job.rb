# frozen_string_literal: true

class NoOpJob < ApplicationJob
  def perform
    # no op
  end
end
