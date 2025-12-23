# frozen_string_literal: true

class Seminar::SeminarComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper
  include SeminarsHelper

  def initialize(seminar, current_user, short: false)
    @seminar = seminar
    @current_user = current_user
    @short = short
  end

  def css_classes(seminar)
    res = "seminar"
    res += seminar.past? ? " past" : " future"
    res += " seminar-serial" if seminar.serial_id
    res += " seminar-cycle" if seminar.cycle_id
    res += " seminar-conference" if seminar.conference_id
    res
  end
end
