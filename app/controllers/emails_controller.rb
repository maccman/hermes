require 'mail'

class EmailsController < ApplicationController
  skip_before_filter :keepsafe
  skip_before_filter :verify_authenticity_token
  
  def create
    from      = params[:from]
    to        = params[:to] || params[:recipient]
    cc        = params[:cc]
    bcc       = params[:bcc]
    subject   = params[:subject]
    body      = params[:text] || params["stripped-text"] || params[:plain]
    headers   = params[:headers] && Mail.new(params[:headers])
    
    body      = strip(body)
    from_user = User.for(from).first
    to_users  = User.for([to, cc, bcc].join(','))
    
    to_users.each do |user|
      message = Message.new(
        uid:         headers.try(:message_id),
        subject:     subject,
        body:        body,
        in_reply_to: headers.try(:in_reply_to)
      )
    
      message.from_user = from_user
      message.to        = to_users
      message.user      = user
      message.save!
    end
    
    head :ok
  end
  
  protected
    def strip(body)
      body = body.split(/^-----Original Message-----/, 2)[0]
      body = body.split(/^________________________________/, 2)[0]
      body = body.split(/^On .+ wrote:(\n|\r\n)/, 2)[0]
      body = body.split(/^---? ?(\n|\r\n)/, 2)[0]
      body.gsub!("Sent from my iPhone", "")
      body.gsub!("Sent from my BlackBerry", "")
      body.strip!
      body
    end
end
