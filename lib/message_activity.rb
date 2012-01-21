module MessageActivity extend self
  FROM_EMAIL_PATTERNS = [
    /no-?reply/,
    /\+activity/,
    /facebookmail.com/,
    /linkedin.com/,
    /foursquare.com/,
    /postmaster.twitter.com/,
    /info@meetup.com/,
    /friendfeed.com/,
    /calendar-notification@google.com/,
    /support@plancast.com/,
    /github.com/,
    /googlegroups.com/
  ]
  
  def match?(message)
    from  = message.from_user
    email = from && from.email
    return false unless email
    
    !!(FROM_EMAIL_PATTERNS.find {|reg| reg =~ email })
  end
end