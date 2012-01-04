module DMSender extend self
  def message(to_user, message)
    # TODO - add rescue, truncation, urls
    from_user = message.from_user
    from_user.twitter.direct_message_create(
      to_user.handle, 
      message.body
    )
  end
end