class EmailsController < ApplicationController
  skip_before_filter :keepsafe
  
  def create
    from      = params[:from]
    to        = params[:to] || params[:recipient]
    subject   = params[:subject]
    body      = params[:text] || params["stripped-text"] || params[:plain]

    to_user = User.find_by_handle!(Mail::Address.new(to).local)
    
    message = Message.new(
      subject: subject,
      body:    strip(body)
    )
    
    message.from_user = User.for(from).first
    message.to        = [to_user]
    message.user      = to_user
    message.save!
    
    head :ok
  end
  
  protected
    def strip(body)
      body = body.split(/^-----Original Message-----/, 2)[0]
      body = body.split(/^________________________________/, 2)[0]
      body = body.split(/^On .+ wrote:$/, 2)[0]
      body = body.split(/^-- ?$/, 2)[0]
      body.gsub!("Sent from my iPhone", "")
      body.gsub!("Sent from my BlackBerry", "")
      body
    end
end
