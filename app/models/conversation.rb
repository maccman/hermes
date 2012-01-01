class Conversation < ActiveRecord::Base
  has_many :messages
end
