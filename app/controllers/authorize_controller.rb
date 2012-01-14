class AuthorizeController < ApplicationController
  skip_before_filter :keepsafe
  before_filter :require_user, :only => :google
  
  def google
    self.current_user.link_google!(
      request.env["omniauth.auth"]
    )
    redirect_to "/"
  end
  
  def create
    self.current_user = User.authorize_twitter!(
      request.env["omniauth.auth"]
    )
    redirect_to "/"
  end
  
  def failure
    raise "OAuth failure - #{params[:message]}"
  end
  
  def destroy
    reset_session
    cookies.delete(:user_id)
    render :text => "Logged out"
  end
end