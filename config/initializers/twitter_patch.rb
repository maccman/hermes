class OmniAuth::Strategies::OAuth
  # Stop rescuing in OAuth
  def callback_phase
    raise OmniAuth::NoSessionError.new("Session Expired") if session['oauth'].nil?

    request_token = ::OAuth::RequestToken.new(consumer, session['oauth'][name.to_s].delete('request_token'), session['oauth'][name.to_s].delete('request_secret'))

    opts = {}
    if session['oauth'][name.to_s]['callback_confirmed']
      opts[:oauth_verifier] = request['oauth_verifier']
    else
      opts[:oauth_callback] = callback_url
    end

    @access_token = request_token.get_access_token(opts)
    super
  end
end

