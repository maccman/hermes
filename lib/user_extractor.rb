require 'mail'
require 'twitter'

module UserExtractor extend self
  def extract_handle(str)
    Twitter::Extractor.extract_reply_screen_name(str)
  end
  
  def extract_email(str)
    email = Mail::Address.new(str)
    email.domain && email.address
  end
  
  def extract(array)
    emails  = []
    handles = []
    
    Array(array).each do |str|
      if handle = extract_handle(str)
        handles << handle
      elsif email = extract_email(str)
        emails << email
      end
    end
    
    {handles: handles, emails: emails}
  end
end