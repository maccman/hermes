Airbrake.configure do |config|
 config.api_key	= '0b035490bc419c1eeb45b7245cefd094'
 config.host		= 'maccman-errbit.herokuapp.com'
 config.port		= 80
 config.secure	= config.port == 443
end