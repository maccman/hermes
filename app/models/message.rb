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
  attr_accessible :to, :subject, :body, :sent_at
  
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
  
    def create_conversation
      return if conversation_id? or !@to
      self.conversation = Conversation.between!(user, from_user, *User.for(@to))
      self.conversation.read = false
      self.conversation.save!
    end
    
    def send_message
      return unless from_user == user
      
      to_users.each do |to_user|
        if user.member?
          message = Message.new(
            to:      to,
            subject: subject,
            body:    body,
            sent_at: sent_at
          )
          message.user      = to_user
          message.from_user = user
          message.save!
        else
          # TODO - Send DM or Email...
        end
      end
    end
end
