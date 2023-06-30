# frozen_string_literal: true

class ArgumentsTagComponent < ViewComponent::Base
  def initialize(seminar)
    @seminar = seminar
    @arguments = seminar.arguments.load
  end

  def render?
    @arguments.any?
  end
end
