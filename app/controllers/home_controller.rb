class HomeController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:index, :totem]

  # Prossimi sono quelli a partire da tutto oggi
  def index
    @seminars = Seminar.order('seminars.date ASC').future.includes([:documents, :topics, :room, :cycle, :repayment])
  end

  def totem
    @seminars = Seminar.order('seminars.date ASC').future.includes([:documents, :topics, :room, :repayment])
    render layout: nil
  end
end
