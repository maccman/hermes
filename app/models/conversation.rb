class Conversation < ActiveRecord::Base
  belongs_to :user

  has_many :conversation_users
  has_many :to_users, :through => :conversation_users, :source => :user

  has_many :messages
  
  before_save   :set_defaults
  
  validates_presence_of :user_id
  validates_length_of   :to_users, :within => 1..20
  validate :valid_users  
  
  # Find all conversations where conversations.user is user, and all conversation_users.user_id are equal to_ids
  scope :between, lambda {|from, *to| 
    includes(:conversation_users).where("conversations.user_id = ? AND conversation_users.user_id IN (?)", from.id, to)
  }
  
  scope :for_user, lambda {|user|
    where(:user_id => user && user.id)
  }
  
  scope :for_token, lambda {|token|
    where(:access_token => token)
  }
  
  scope :latest, order("received_at DESC")
  
  attr_accessor :client_id
  attr_accessible :read
  
  class << self
    def between!(user, from, *to)
      # If the message was from a different person, then the
      # conversation needs to include them too
      to |= [from]
      
      # To must not include the current user
      to -= [user]
      
      # Find or new conversation
      conversation = between(user, *to).first 
      conversation ||= self.new.tap do |conv|
        conv.user     = user
        conv.to_users = to
      end
    end
  end
  
  def last_message
    messages.order("sent_at DESC").first
  end
  
  def current_subject
    messages.order("sent_at DESC").where("subject IS NOT NULL").first.try(:subject)
  end
  
  def serializable_hash(options = nil)
    # TODO - limit amount of messages a conversation includes by default
    super((options || {}).merge(
      :include => [:user, :to_users, :messages]
    ))
  end
  
  def to_s
    handle || email
  end
  
  protected  
    def set_defaults
      self.received_at = current_time_from_proper_timezone
    end
  
    def valid_users
      if to_users.include?(user)
        errors.add("users", "can't start a conversation with yourself")
      end
    end
end