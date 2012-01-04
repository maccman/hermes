class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user
  belongs_to :from_user, :class_name => "User"
  
  validates_presence_of :from_user, :conversation, :user, :body
  
  before_save       :set_defaults
  before_validation :create_conversation, :on => :create
  after_create      :send_message
  
  scope :for_user, lambda {|user|
    where(:user_id => user && user.id)
  }
  
  scope :latest, order(:sent_at => 'ASC')
  
  attr_accessor   :to
  attr_accessible :to, :subject, :body, :sent_at
  
  class << self
    def duplicate!(to_user, message)
      duplicate = Message.new(
        to:      message.to,
        subject: message.subject,
        body:    message.body,
        sent_at: message.sent_at
      )
      
      duplicate.user      = to_user
      duplicate.from_user = message.user
      duplicate.save!
      duplicate
    end
  end
  
  def to
    to_users.map(&:to_s)
  end
  
  def to_users
    (conversation_id? && conversation.to_users) || []
  end
  
  def serializable_hash(options = nil)
    super((options || {}).merge(
      :include => :from_user,
      :methods => :to,
      :except  => [:from_user_id, :user_id]
    ))
  end
    
  protected
    def set_defaults
      self.sent_at ||= Time.now
    end
  
    # Create a conversation if it doesn't exist
    # with the message's participants
    def create_conversation
      return if conversation_id? or !@to
      self.conversation = Conversation.between!(
        user, from_user, *User.for(@to)
      )
      self.conversation.read = false
      self.conversation.save!
    end
    
    def send_message
      return unless from_user == user
      
      to_users.each do |to_user|
        if to_user.member?
          # Duplicate message internally
          Message.duplicate!(to_user, self)
        elsif to_user.email?
          # Else email
          UserMailer.message(to_user, self).deliver
        elsif to_user.handle?
          # Or DM
          DMSender.message(to_user, self)
        end
      end
    end
end