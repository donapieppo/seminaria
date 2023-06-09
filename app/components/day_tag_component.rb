# frozen_string_literal: true

class DayTagComponent < ViewComponent::Base
  def initialize(what)
    if what.is_a?(Seminar)
      if what.conference
        @conference = what.conference
      else
        @seminar = what
        @month = I18n.l(@seminar.date, format: :month)
        @nday  = I18n.l(@seminar.date, format: :nday)
        # week day for future seminar or year if already done
        @detail = (@seminar.date < Time.now) ? @seminar.date.year : I18n.l(@seminar.date, format: :wday).capitalize
      end
    else
      @conference = what
    end
  end
end
