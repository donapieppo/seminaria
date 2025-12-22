# frozen_string_literal: true

class HourTagComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(seminar)
    @seminar = seminar
  end
end
