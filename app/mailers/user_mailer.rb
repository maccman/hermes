class UserMailer < ActionMailer::Base
  default from: "notify@#{Rails.config.domain}"
  
  def send_message(to_user, message)
    @to_user      = to_user
    @from_user    = message.from_user
    @message      = message
    @conversation = message.conversation
    
    previous_msgs = @conversation.messages.where("id != ?", @message.id).all
    
    mail(
      :to           => @to_user.email, 
      :from         => @from_user.email,
      :reply_to     => "#{@from_user.handle}@#{Rails.config.domain}", 
      :subject      => @conversation.current_subject || "#{Rails.config.name} message",
      "In-Reply-To" => previous_msgs.first.try(:uid),
      "References"  => previous_msgs.map(&:uid).reverse.join(" ")
    )
  end
end