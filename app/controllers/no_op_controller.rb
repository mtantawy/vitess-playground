# frozen_string_literal: true

class NoOpController < ApplicationController
  def run
    render(json: NoOpJob.perform_now)
  end
end
