user1 = User.create(handle: "maccman", name: "Alex MacCaw")
user2 = User.create(handle: "mjackson", name: "Michael Jackson")

conversation = Conversation.new
conversation.from_user = user1
conversation.to_users  = [user2]
conversation.save!

message = Message.new
message.body = "Hello World"
message.conversation = conversation
message.from_user = user1
message.to_users  = [user2]
message.save!

message = Message.new
message.body = "Hello World 2"
message.conversation = conversation
message.from_user = user1
message.to_users  = [user2]
message.save!