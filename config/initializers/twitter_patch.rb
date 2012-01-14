class OmniAuth::Strategies::OAuth
  # Stop rescuing in OAuth
  def callback_phase
    raise OmniAuth::NoSessionError.new("Session Expired") if session['oauth'].nil?

    request_token = ::OAuth::RequestToken.new(consumer, session['oauth'][name.to_s].delete('request_token'), session['oauth'][name.to_s].delete('request_secret'))
    
    p request_token

    opts = {}
    if session['oauth'][name.to_s]['callback_confirmed']
      opts[:oauth_verifier] = request['oauth_verifier']
    else
      opts[:oauth_callback] = callback_url
    end
    
    p opts

    @access_token = request_token.get_access_token(opts)
    super
  
   rescue ::Timeout::Error => e
     fail!(:timeout, e)
   rescue ::Net::HTTPFatalError, ::OpenSSL::SSL::SSLError => e
     fail!(:service_unavailable, e)
   rescue ::OAuth::Unauthorized => e
     fail!(:invalid_credentials, e)
   rescue ::MultiJson::DecodeError => e
     fail!(:invalid_response, e)
   rescue ::OmniAuth::NoSessionError => e
     fail!(:session_expired, e)
  end
end

