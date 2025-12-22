# frozen_string_literal: true

class Conference::ConferenceComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(conference, current_user)
    @conference = conference
    @current_user = current_user
    @conference_policy = ConferencePolicy.new(@current_user, @conference)
  end
end
