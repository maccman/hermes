class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user
  belongs_to :from_user, :class_name => "User"
  
  validates_presence_of :from_user, :conversation, :user, :body
  
  before_save  :set_defaults
  before_validation :create_conversation, :on => :create
  after_create :send_message
  
  scope :for_user, lambda {|user|
    where(:user_id => user && user.id)
  }
  
  scope :latest, order(:sent_at => 'ASC')
  
  attr_accessor :to
  attr_accessible :subject, :body, :starred, :sent_at, :to
  
  def to
    to_users.map(&:to_s)
  end
  
  def to_users
    (conversation_id? && conversation.to_users) || []
  end
    
  protected
    def set_defaults
      self.sent_at ||= Time.now
    end
  
    def create_conversation
      return if conversation_id? or !@to
      self.conversation = Conversation.between!(user, *User.for(@to))
      self.conversation.read = false
      self.conversation.save!
    end
    
    def send_message
      # Duplicate message locally if to.member?
      # Send email if !to.member? and to.email
    end
end
