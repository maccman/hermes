require 'mail'

class EmailsController < ApplicationController
  skip_before_filter :keepsafe
  skip_before_filter :verify_authenticity_token
  
  def create
    mail      = params[:headers] && Mail.new(params[:headers])
    from      = params[:from]
    to        = params[:to] || params[:recipient] || ""
    cc        = params[:cc]
    bcc       = params[:bcc]
    subject   = params[:subject]
    body      = params[:text] || params["stripped-text"] || params[:plain]
    
    if forwarded = mail && mail["X-Forwarded-For"]
      to += ("," + forwarded.to_s.split(" ").first)
    end
    
    body      = subject if body.blank?
    body      = MailBody.strip(body)
    from_user = User.for(from).first
    to_users  = User.for([to, cc, bcc].join(","))
    
    to_users.each do |user|
      message = Message.new(
        subject: subject,
        body:    body,
      )
      
      message.headers   = mail
      message.from_user = from_user
      message.to        = to_users
      message.user      = user
      message.activity  = MailActivity.match?(to, mail, body)
      message.save
    end
    
    head :ok
  end
end