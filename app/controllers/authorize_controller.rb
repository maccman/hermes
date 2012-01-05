class AuthorizeController < ApplicationController
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
    render :text => "Logged out"
  end
end