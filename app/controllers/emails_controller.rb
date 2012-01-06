class EmailsController < ApplicationController
  def create
    from      = params[:from]
    to        = params[:to]
    subject   = params[:subject]
    body      = params[:text]

    # TODO - Check domain and find by handle instead
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
