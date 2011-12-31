class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate
  
  protected
    def authenticate
      request.local? || authenticate_or_request_with_http_digest do |username|
        Rails.config.users[username]
      end
    end
end