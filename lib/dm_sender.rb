module DMSender extend self
  extend ActionView::Helpers::TextHelper
  extend ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers
  default_url_options[:host] = Rails.config.domain
  
  def send_message(to_user, message)
    conversation = message.conversation
    conversation_url = url_for(
      controller:   'conversations', 
      action:       'show', 
      id:           conversation.id, 
      access_token: conversation.access_token
    )
    
    # Length is Twitter limit, minus space, minus tco
    body = truncate(message.body, length: 140 - 1 - 20)
    body += " (#{conversation_url})"
    
    from_user = message.from_user
    from_user.twitter.direct_message_create(
      to_user.handle, 
      body
    )
  rescue Twitter::Error
  end
end