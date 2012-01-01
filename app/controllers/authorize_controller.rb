class AuthorizeController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    # cookies.permanent.signed[:handle] = auth.info.nickname
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