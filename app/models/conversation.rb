class Conversation < ActiveRecord::Base
  belongs_to :user

  has_many :conversation_users
  has_many :to_users, :through => :conversation_users, :source => :user

  has_many :messages
  
  before_save :set_defaults
  
  validates_presence_of :user_id
  validates_length_of   :to_users, :within => 1..20, :on => :create
  
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
    def between(from, *to)
      convos = for_user(from).all(:include => :conversation_users)
      convos = convos.find do |conv|
        conv.conversation_users.map(&:user_id) == to.map(&:id)
      end
      [convos]
    end
  end
  
  def current_subject
    messages.latest_first.where("subject IS NOT NULL").first.try(:subject)
  end
  
  def serializable_hash(options = {})
    # TODO - limit amount of messages a conversation includes by default
    super(options.merge(
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
end