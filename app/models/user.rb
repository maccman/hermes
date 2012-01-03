require 'user_extractor'

class User < ActiveRecord::Base
  validates_uniqueness_of :uid, :allow_blank => true
  
  validates_presence_of :handle, :unless => :email?
  validates_presence_of :email, :unless => :handle?
  
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
    def for(to_users)
      users  = []
      result = UserExtractor.extract(to_users)
      result[:handles].each do |handle|
        users << find_or_create_by_handle(handle)
      end
      result[:emails].each do |email|
        users << find_or_create_by_email(email)
      end
      users
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
    twitter_token? && twitter_secret?
  end
  
  alias_method :twitter?, :member?
end