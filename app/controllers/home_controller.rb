class HomeController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:totem]

  def totem
    authorize :home
    @seminars = Seminar.order("seminars.date ASC").date_today.future.includes([:arguments, :place])
    if @seminars.count == 0
      @seminars = Seminar.order("seminars.date ASC").future.includes([:documents, :arguments, :place, :repayment]).limit(3).to_a
    end
    render layout: nil
  end

  def choose_organization
    authorize :home
    @organizations = Organization.all
  end

  def stats
    authorize :home
    @seminars_per_years = Seminar.find_by_sql("select YEAR(date) as y, count(*) as c from seminars where conference_id is null group by y")
    @conferences_per_years = Conference.find_by_sql("select YEAR(start_date) as y, count(*) as c from conferences group by y")
  end
end
