require 'oauth2'

ENV['OAUTH_DEBUG'] = 'true'

class ZoomOauth

  # The client MUST NOT use the authorization code more than once
  def initialize
    @client = OAuth2::Client.new(ENV.fetch('SEMINARIA_ZOOM_CLIENT_ID'), 
                                 ENV.fetch('SEMINARIA_ZOOM_CLIENT_SECRET'),
                                 site: 'https://api.zoom.us',
                                 authorize_url: 'https://zoom.us/oauth/authorize', 
                                 token_url: 'https://zoom.us/oauth/token')
  end

  def authorize_url(state=nil)
    @client.auth_code.authorize_url(redirect_uri: ENV.fetch('SEMINARIA_ZOOM_REDIRECT_URI'), state: state)
  end

  def get_token(code)
    @client.auth_code.get_token(code, redirect_uri: ENV.fetch('SEMINARIA_ZOOM_REDIRECT_URI'))
  end

  def get_meetings(code)
    token = get_token(code)
    r = token.get('/v2/users/me/meetings', params: { 'type' => 'upcoming' })
    r.parsed
  end

  def get_user(code)
    token = get_token(code)
    r = token.get('/v2/users/me', params: { })
    r.parsed
  end

  # https://marketplace.zoom.us/docs/api-reference/zoom-api/meetings/meetingcreate
  # "timezone": "America/New_York"
  # "start_time": "2019-08-30T22:00:00Z"
  # "settings": {
  #   "approval_type": 2, "audio": "both", "enforce_login": false, "host_video": false, "join_before_host": true, 
  #   "mute_upon_entry": false, "waiting_room": false ....
  def create_meeting(code, seminar)
    body = { 'type'       => 2,
             'topic'      => seminar.zoom_topic, 
             'start_time' => seminar.start_time.to_formatted_s(:iso8601), 
             'duration'   => seminar.duration,
             'timezone'   => 'Europe/Rome' }
    token = get_token(code)
    Rails.logger.info(body.to_json)
    Rails.logger.info("-------------------------------")
    # OAuth2::Response
    r = token.post('/v2/users/me/meetings', { body: body.to_json, headers: { 'Content-Type' => "application/json" }})
    Rails.logger.info(r.inspect)
    data = r.parsed
    if data["uuid"]
      zm = seminar.build_zoom_meeting(id:        data["id"], 
                                      uuid:      data["uuid"],
                                      start_url: data["start_url"],
                                      join_url:  data["start_url"])
      if zm.save
        return zm
      end
    end
    return nil
  end
end