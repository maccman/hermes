class Conversation < ActiveRecord::Base
  belongs_to :from_user, :class_name => "User"

  has_many :conversation_users
  has_many :to_users, :through => :conversation_users, :source => :user

  has_many :messages
  
  validates_presence_of :from_user_id
  validates_length_of   :to_users, :within => 1..20
  
  scope :between, lambda {|from, *to| 
    where(:from_user_id => from.id, :to_users => to).first
  }
  
  scope :for_user, lambda {|user|
    where(:from_user_id => user && user.id)
  }
  
  class << self
    def between!(from, *to)
      between(from, *to) || self.new(:from_user => from, :to_users => to)
    end
  end
  
  def serializable_hash(options = nil)
    # TODO - limit amount of messages a conversation includes by default
    super((options || {}).merge(
      :include => [:from_user, :to_users, :messages]
    ))
  end
end