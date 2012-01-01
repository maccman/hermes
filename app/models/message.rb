class Message < ActiveRecord::Base
  belongs_to :conversation
  
  validates_presence_of :conversation_id
end
