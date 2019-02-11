class HomeController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:index, :totem]

  def totem
    @seminars = Seminar.order('seminars.date ASC').future.includes([:documents, :arguments, :place, :repayment])
    render layout: nil
  end
end
