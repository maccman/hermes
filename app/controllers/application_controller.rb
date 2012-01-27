class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :keepsafe
  before_filter :login_with_access_token
  
  protected    
    def keepsafe
      request.local? || authenticate_or_request_with_http_digest do |username|
        Rails.config.users[username]
      end
    end
    
    def login_with_access_token
      if params[:access_token].present? 
        self.current_user = User.find_by_access_token(params[:access_token])
      end
    end
    
    def current_user=(user)
      cookies.permanent.signed[:user_id] = user && user.id
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = cookies.signed[:user_id].present? && User.find(cookies.signed[:user_id])
    end
    
    def logged_in?
      !!current_user
    end
    
    def require_user
      unless current_user
        respond_to do |format|
          format.html do
            store_location
            redirect_to authorize_url          
          end
          
          format.all do
            head(:unauthorized)
          end
        end
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end
    
    def redirect_back_or_default(default)
      return_to = session[:return_to] || params[:return_to]
      redirect_to(return_to.present? ? return_to : default)
      session[:return_to] = nil
    end
    
    helper_method :logged_in?, :current_user
    
    def publish(type, record)
      session_id = request.headers['X-Session-ID']
      JuggernautObserver.publish(type, record, except: session_id)
    end
end