class User < ActiveRecord::Base
  class << self
    # Find or new user by Twiter oauth information
    def authorize_twitter!(auth)
      return unless auth && auth.uid
    
      user = self.find_by_uid(auth.uid) || self.new
      user.uid          = auth.uid
      user.handle       = auth.info.nickname
      user.name         = auth.info.name
      user.description  = auth.info.description
      user.avatar_url   = auth.info.image
    
      if auth.provider == "twitter"      
        user.twitter_token  = auth.credentials.token
        user.twitter_secret = auth.credentials.secret
      end
    
      user.save!
      user
    end
    
    # Find or new user by handle or email address
    def for(attrs)
      query = self
    
      if attrs[:handle]
        query.where(:handle => attrs[:handle])
      elsif attrs[:email]
        query.where(:email => attrs[:email])
      end
    
      query.first || self.new(
        :handle => attrs[:handle], 
        :email => attrs[:email]
      )
    end
  end
  
  def twitter
    Twitter::Client.new(
      :consumer_key    => Rails.config.twitter.token,
      :consumer_secret => Rails.config.twitter.secret,
      :oauth_token     => self.twitter_token,
      :oauth_token_secret => self.twitter_secret
    )
  end
  
  def member?
    twitter_token?
  end
end