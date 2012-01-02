class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :from_user, :class_name => "User"
  
  has_many :message_users
  has_many :to_users, :through => :message_users, :source => :user
  
  validates_presence_of :from_user_id, :conversation_id, :body
  validates_length_of   :to_users, :within => 1..20
  
  before_save  :set_defaults
  before_validation :create_conversation, :on => :create
  after_create :send_message
  
  scope :for_user, lambda {|user|
    where(:from_user_id => user && user.id)
  }
  
  scope :with_user, lambda {|user|
    where('from_user_id = :id OR to_user_ids IN :id', :id => user && user.id)
  }
  
  def to=(array)
    # Array(array).map {}
    # Extract emails/handles
    Extractor.parse(str)
  end
    
  protected
    def set_defaults
      self.sent_at ||= Time.now
    end
  
    def create_conversation
      return if conversation_id?
      self.conversation = Conversation.between!(from_user, *to_users)
      self.conversation.read = false
      self.conversation.save!
    end
    
    def send_message
      # Create message on Twitter if from.twitter and to.handle
      # Duplicate message locally if to.member?
      # Send email if !to.member? and to.email
      # TODO - what about groups?
    end
end
