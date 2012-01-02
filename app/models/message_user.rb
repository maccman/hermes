class MessageUser < ActiveRecord::Base
  belongs_to :message
  belongs_to :user
  
  validates_presence_of :message_id, :user_id
end
