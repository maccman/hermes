class EmailsController < ApplicationController
  skip_before_filter :keepsafe
  
  def create
    from      = params[:from]
    to        = params[:to] || params[:recipient]
    subject   = params[:subject]
    body      = params[:text] || params["stripped-text"] || params[:plain]

    to_user = User.find_by_handle!(to.split('@', 2).first)
    
    message = Message.new(
      subject: subject,
      body:    body
    )
    
    message.from_user = User.for(to).first
    message.to        = [to_user.to_s]
    message.user      = to_user
    message.save!
    
    head :ok
  end
end
