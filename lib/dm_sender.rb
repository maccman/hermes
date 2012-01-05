module DMSender extend self
  def send_message(to_user, message)
    # TODO - add rescue, truncation, urls
    from_user = message.from_user
    from_user.twitter.direct_message_create(
      to_user.handle, 
      message.body
    )
  rescue Twitter::Error
  end
end