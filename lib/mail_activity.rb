module MailActivity extend self
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
  
  HEADERS = %w{ List-Unsubscribe List-Id X-AWS-Outgoing X-Sendgrid-EID Precedence }
  
  def match?(from, mail, body)
    return true if HEADERS.find {|header| mail[header] }
    return true if BODY_PATTERNS.find {|reg| reg =~ body }
    return true if FROM_EMAIL_PATTERNS.find {|reg| reg =~ to }
    false
  end
end