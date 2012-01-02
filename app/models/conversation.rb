class Conversation < ActiveRecord::Base
  belongs_to :from_user, :class_name => "User"

  has_many   :conversation_users
  belongs_to :to_users, :through => :conversation_users

  has_many   :messages
  
  validates_presence_of :user_id
  
  scope :between, lambda {|from, *to| 
    where(:from_user => from, :to_users => to).first
  }
  
  class << self
    def for(from, *to)
      between(from, *to) || self.new(:from_user => from, :to_users => to)
    end
  end
end