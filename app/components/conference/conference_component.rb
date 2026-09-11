# frozen_string_literal: true

class Conference::ConferenceComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(conference, current_user, first_in_month: false)
    @conference = conference
    @current_user = current_user
    @first_in_month = first_in_month
    @conference_policy = ConferencePolicy.new(@current_user, @conference)
  end
end
