class UserMailer < ActionMailer::Base
  default from: "notify@#{Rails.config.domain}",
          subject: "#{Rails.config.name} message"
  
  def send_message(to_user, message)
    @to_user   = to_user
    @from_user = message.from_user
    @message   = message
    
    mail(
      :to           => @to_user.email, 
      :from         => @from_user.email,
      :reply_to     => "#{@from_user.handle}@#{Rails.config.domain}", 
      :subject      => @message.conversation.current_subject,
      'In-Reply-To' => @message.conversation.last_message.try(:uid)
    )
  end
end