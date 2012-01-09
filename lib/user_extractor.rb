require 'user'
require 'mail'
require 'twitter'

module UserExtractor extend self
  def extract_handle(str)
    Twitter::Extractor.extract_mentioned_screen_names(str)[0]
  end
  
  def extract_email(str)
    email = Mail::Address.new(str)
    email.domain && email.address
  end
  
  def extract(array)
    if array.is_a?(String)
      array = array.split(',')
    end
    
    users = []
    
    Array(array).each do |value|
      if value.is_a?(User)
        users << value
      elsif handle = extract_handle(value)
        users << User.find_or_create_by_handle(handle)
      elsif email = extract_email(value)
        users << User.find_or_create_by_email(email)
      end
    end
    
    users.uniq
  end
end