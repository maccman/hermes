class UserMailer < ActionMailer::Base
  default from: "notify@#{Rails.config.domain}"
  
  def send_message(to_user, message)
    @to_user      = to_user
    @from_user    = message.from_user
    @message      = message
    @conversation = message.conversation
    
    previous_msgs = @conversation.messages.latest_first.where("id != ?", @message.id).all
    previous_msgs = previous_msgs.map(&:uid).map {|v| "<#{v}>" }
        
    mail(
      :message_id   => "<#{message.uid}>",
      :to           => @to_user.email, 
      :from         => "#{@from_user.to_name} <#{@from_user.email}>",
      :reply_to     => @from_user.app_email,
      :subject      => @conversation.current_subject || "#{Rails.config.name} message",
      "In-Reply-To" => previous_msgs.first,
      "References"  => previous_msgs.reverse.join(" ")
    )
  end
end