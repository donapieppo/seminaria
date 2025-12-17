# frozen_string_literal: true

class Seminar::SeminarComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(seminar, current_user, short: false)
    @seminar = seminar
    @current_user = current_user
    @short = short
  end
end
