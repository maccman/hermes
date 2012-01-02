class ConversationUser < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user
  
  validates_presence_of :conversation_id, :user_id
end