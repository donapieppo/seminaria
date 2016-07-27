class HomeController < ApplicationController
  skip_filter :redirect_unsigned_user, only: [:index, :totem]

  # Prossimi sono quelli a partire da tutto oggi
  def index
    @seminars = Seminar.order('seminars.date ASC').future.includes([:documents, :arguments, :place, :cycle, :repayment])
  end

  def totem
    @seminars = Seminar.order('seminars.date ASC').future.includes([:documents, :arguments, :place, :repayment])
    render layout: nil
  end
end
