class Conversation < ActiveRecord::Base
  belongs_to :user

  has_many :conversation_users
  has_many :to_users, :through => :conversation_users, :source => :user

  has_many :messages
  
  before_save :set_defaults
  
  validates_presence_of :user_id
  validates_length_of   :to_users, :within => 1..20, :on => :create
  validate :valid_users
  
  # Find all conversations where conversations.user is user, and all conversation_users.user_id are equal to_ids
  scope :between, lambda {|from, *to| 
    includes(:conversation_users).where("conversations.user_id = ? AND conversation_users.user_id IN (?)", from.id, to)
  }
  
  scope :for_user, lambda {|user|
    where(:user_id => user && user.id)
  }
  
  scope :latest,   where("messages.activity = ?", false).order("received_at DESC")
  scope :activity, where("messages.activity = ?", true).order("received_at DESC")
  scope :starred,  where("messages.starred = ?", true).order("received_at DESC")
  
  attr_accessor :client_id
  attr_accessible :read
  
  class << self
    def between(from, *to)
      convos = for_user(from).all(:include => :conversation_users)
      convos = convos.find do |conv|
        conv.conversation_users.map(&:user_id) == to.map(&:id)
      end
      [convos]
    end
  end
  
  def between(user, from, *to)
    # If the message was from a different person, then the
    # conversation needs to include them too
    to |= [from]
   	
    # To must not include the current user
    to -= [user]

    self.user     = user
   	self.to_users = to
  end
  
  def current_subject
    messages.latest_first.where("subject IS NOT NULL").first.try(:subject)
  end
  
  def starred?
    messages.any?(&:starred?)
  end
  
  alias_method :starred, :starred?
    
  def activity?
    messages.any? && messages.all?(&:activity?)
  end
  
  alias_method :activity, :activity?
  
  def serializable_hash(options = {})
    # TODO - limit amount of messages a conversation includes by default
    super(options.merge(
      :methods => [:activity, :starred],
      :include => [:user, :to_users, :messages]
    ))
  end
  
  def to_s
    handle || email
  end
  
  def touch_received_at
    self.received_at = current_time_from_proper_timezone
  end
  
  protected  
    def set_defaults
      self.uid ||= Mail::MessageIdField.new.message_id
      true
    end
    
    def valid_users 	
      if to_users.include?(user)
        errors.add("users", "can't start a conversation with yourself")
      end
    end
end