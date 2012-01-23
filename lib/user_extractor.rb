require 'user'
require 'mail'
require 'twitter'

module UserExtractor extend self
  def extract_handle(str)
    Twitter::Extractor.extract_mentioned_screen_names(str)[0]
  end
  
  def extract_mail(str)
    address = Mail::Address.new(str)
    address.domain && address
  end
  
  def extract(array)
    if array.is_a?(String)
      array = array.split(/,(?=(?:[^']*'[^']*')*[^']*$)/)
    end
    
    users = []
    
    Array(array).each do |value|
      next if value.blank?
      if value.is_a?(User)
        users << value
      elsif handle = extract_handle(value)
        users << User.from_handle(handle)
      elsif mail = extract_mail(value)
        users << User.from_mail(mail)
      end
    end
    
    users.uniq
  end
end