Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :google, Rails.config.google.token, Rails.config.google.secret
  provider :google_oauth2, Rails.config.google.token, Rails.config.google.secret
end