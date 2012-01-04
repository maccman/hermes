class UserMailer < ActionMailer::Base
  default from: "notify@#{Rails.config.domain}"
  
  def send_message(to_user, message)
    @to_user   = to_user
    @from_user = message.from_user
    @message   = message
    
    mail(
      to: @to_user.email, 
      from: @from_user.email, 
      subject: "#{Rails.config.name} message"
    )
  end
end
