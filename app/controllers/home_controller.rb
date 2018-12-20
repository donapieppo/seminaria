class HomeController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:index, :totem]

  def totem
    @seminars = Seminar.order('seminars.date ASC').future.includes([:documents, :arguments, :place, :repayment])
    # @highlights = Highlight.priorized.to_a
    @highlights = []
    render layout: nil
  end
end
