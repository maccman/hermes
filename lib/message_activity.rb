module MessageActivity extend self
  FROM_EMAIL_PATTERNS = [
    /no-?reply/,
    /\+activity/,
    /amazon.com/,
    /facebookmail.com/,
    /linkedin.com/,
    /foursquare.com/,
    /postmaster.twitter.com/,
    /info@meetup.com/,
    /friendfeed.com/,
    /calendar-notification@google.com/,
    /support@plancast.com/,
    /github.com/,
    /googlegroups.com/,
    /^notifications@/,    
    /^chat@/
  ]
  
  BODY_PATTERNS = []
  
  HEADERS = %w{ List-Unsubscribe List-Id X-AWS-Outgoing Precedence }
  
  def match?(message)
    return true if HEADERS.find {|header| message.headers.has_key?(header) }
    return true if BODY_PATTERNS.find {|reg| reg =~ message.body }
    message.to.each do |to|
      return true if FROM_EMAIL_PATTERNS.find {|reg| reg =~ to }
    end
    false
  end
end