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

  def with_seminar_link(&block)
    content = capture(&block)
    return content if @seminar.in_conference?

    link_to single_page_path(@seminar.single_page_attributes) do
      content
    end
  end
end
