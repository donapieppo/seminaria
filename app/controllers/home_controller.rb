class HomeController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:index, :totem]

  # Prossimi sono quelli a partire da tutto oggi
  def index
    if params[:only_current_user] # see config/routes.rb
      @title = "Seminari inseriti da #{current_user.cn}"  
      @seminars = current_user.seminars.order('seminars.date DESC')
    else
      @title = "Prossimi seminari"
      @seminars = Seminar.order('seminars.date ASC').future
    end
    @seminars = @seminars.includes([:documents, :topics, :room])
    respond_to do |format|
      format.html
      format.json { render json: @seminars }
    end
  end

  def totem
    @seminars = Seminar.order('seminars.date ASC').future.includes([:documents, :topics, :room, :repayment])
    render layout: nil
  end
end
