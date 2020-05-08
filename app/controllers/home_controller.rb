class HomeController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:index, :totem]

  def totem
    authorize :home
    @seminars = Seminar.order('seminars.date ASC').date_today.future.includes([:arguments, :place])
    if @seminars.count == 0
      @seminars = Seminar.order('seminars.date ASC').future.includes([:documents, :arguments, :place, :repayment]).limit(3).to_a
    end
    render layout: nil
  end

  def choose_organization
    authorize :home
    @organizations = Organization.all
  end
end
