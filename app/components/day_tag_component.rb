# frozen_string_literal: true

class DayTagComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(what)
    @conference = if what.is_a?(Seminar)
      what.conference
    else
      what
    end

    @date = if @conference
      @conference.start_date
    else
      what.date
    end

    # week day for future seminar or year if already done
    @detail = (@date < Time.now) ? @date.year : I18n.l(@date, format: :wday).capitalize
  end
end
