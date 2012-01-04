class EmailsController < ApplicationController
  def create
    sender     = params[:sender]
    recipient  = params[:recipient]
    subject    = params[:subject]
    body       = params[:body_plain]

    to_user = User.find_by_email!(recipient)
    
    message = Message.new(
      subject: subject,
      body:    body
    )
    
    message.to_users  = [to_user]
    message.from_user = User.for(recipient).first
    message.save!
    
    head :ok
  end
end
