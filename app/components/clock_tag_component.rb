# frozen_string_literal: true

class ClockTagComponent < ViewComponent::Base
  def initialize(date)
    if date.today?
      @date = date
      @date_string = ((@date < Time.now) ? " iniziato da " : " tra ") + time_ago_in_words(@date)
    end
  end

  def render?
    @date
  end
end
