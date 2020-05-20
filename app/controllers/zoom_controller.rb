class ZoomController < ApplicationController
  def show
    @zoom = ZoomOauth.new
    authorize :zoom
    redirect_to @zoom.authorize_url('show')
  end

  def user
    @zoom = ZoomOauth.new
    authorize :zoom
    redirect_to @zoom.authorize_url('user')
  end

  def create
    @seminar = Seminar.find(params[:seminar_id])
    @zoom = ZoomOauth.new
    authorize :zoom
    redirect_to @zoom.authorize_url(@seminar.id)
  end

  def oauth
    @zoom = ZoomOauth.new
    authorize :zoom
    if params[:code] && params[:state]
      if params[:state] =~/\A\d+\z/
        seminar = Seminar.find(params[:state])

        seminar.update(on_line: true)

        zoom_meeting = @zoom.create_meeting(params[:code], seminar)
        redirect_to edit_seminar_path(seminar, __org__: seminar.organization.code) and return
      else
        case params[:state]
        when 'show'
          raise @zoom.get_meetings(params[:code]).inspect
        when 'user'
          raise @zoom.get_user(params[:code]).inspect
        end
      end
    end
  end

  def list
    if params[:code]
    end
  end
end

