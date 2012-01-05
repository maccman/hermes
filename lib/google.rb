module Google
  class Contact < Hashie::Mash
  end
  
  class Client
    attr_reader :options
    
    def initialize(options = {})
      @options = options
    end
    
    def contacts
      Nestful.get(
        "https://www.google.com/m8/feeds/contacts/default/full", 
        params: {access_token: options[:oauth_token_secret]}
      )
    end
  end
end