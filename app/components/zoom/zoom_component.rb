# frozen_string_literal: true

class Zoom::ZoomComponent < ViewComponent::Base
  def initialize(zoom_meeting)
    @zoom_meeting = zoom_meeting
  end

  def render?
    @zoom_meeting
  end
end


