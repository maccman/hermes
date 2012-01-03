user1 = User.create(handle: "maccman", name: "Alex MacCaw", avatar_url: "https://secure.gravatar.com/avatar/baf018e2cc4616e4776d323215c7136c")
user2 = User.create(handle: "mjackson", name: "Michael Jackson", avatar_url: "https://secure.gravatar.com/avatar/9210a60b1492363560375d9cd6c842de")

conversation = Conversation.new
conversation.to_users  = [user2]
conversation.user = user1
conversation.save!

message = Message.new
message.body = "Hello World"
message.conversation = conversation
message.from_user = user1
message.user = user1
message.save!

message = Message.new
message.body = "Hello World 2"
message.conversation = conversation
message.from_user = user2
message.user = user1
message.save!

message = Message.new
message.body = "Hello again!"
message.conversation = conversation
message.from_user = user1
message.user = user1
message.save!

conversation = Conversation.new
conversation.to_users  = [user1]
conversation.user = user1
conversation.save!

message = Message.new
message.body = "Hello World"
message.conversation = conversation
message.from_user = user1
message.user = user1
message.save!