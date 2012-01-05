module Google
  class Contact
    attr_reader :name, :emails, :email
    
    def initialize(result)
      @name   = result["title"]
      @name   = @name["$t"].blank? ? nil : @name["$t"]
      
      raw_emails = result["gd$email"] || []      
      @emails = raw_emails.map {|e| e["address"] }
      
      @email  = raw_emails.find {|e| e["primary"] == "true" }
      @email  = @email && @email["address"]
    end
    
    def to_s
      if name and email
        %{#{name.inspect} <#{email}>}
      elsif name
        name
      else
        email
      end
    end
  end
  
  class Client
    attr_reader :token, :options
    
    def initialize(token, options = {})
      @token   = token
      @options = options
    end
    
    def contacts
      format Nestful.get(
        "https://www.google.com/m8/feeds/contacts/default/full", 
        params: {
          :alt => "json", 
          "max-results" => 100000, 
          :access_token => token
        }
      )
    end
    
    protected
      def format(result)
        result = ActiveSupport::JSON.decode(result)
        result["feed"]["entry"].map {|c| Contact.new(c) }
      end
  end
end