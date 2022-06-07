# frozen_string_literal: true

class ClockTagComponent < ViewComponent::Base
  def initialize(date)
    @date = date
    @date_string = (@date < Time.now ? ' iniziato da ' :  ' tra ') + time_ago_in_words(@date) 
  end

  def render?
    @date.today? 
  end
end
