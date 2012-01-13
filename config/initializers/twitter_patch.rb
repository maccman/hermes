class OmniAuth::Strategies::Twitter
  # We need to sleep 3 seconds after we have
  # the token, as Twitter unfortunately needs
  # time to propogate data :(
  def callback_phase
    sleep 3
    super
  end
end